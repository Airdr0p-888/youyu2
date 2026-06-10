// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TaxDistributor
 * @dev 独立税费处理合约
 *
 *  职责：
 *    - 接收主合约转来的税费代币
 *    - swap 代币 → BNB
 *    - 按四项分配：营销 / 销毁 / LP / 分红
 *
 *  四项分配（bps，总和 = 10000）：
 *    marketingBps → 营销钱包
 *    burnBps      → 销毁代币（直接发送到 0xdead）
 *    lpBps        → 加流动性（一半 swap BNB + 一半代币）
 *    dividendBps  → 分红合约
 *
 *  主合约在卖出时：
 *    1. transfer 税费代币 → 本合约
 *    2. 调用 tryProcess() 触发处理
 *    → 失败不影响用户交易
 */

// ── Interfaces ──
interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETH(
        uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline
    ) external returns (uint[] memory amounts);
    function addLiquidityETH(
        address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin,
        address to, uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address);
}

// ── Ownable ──
abstract contract Ownable {
    address internal _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor(address owner_) {
        address initOwner = owner_ == address(0) ? msg.sender : owner_;
        _owner = initOwner;
        emit OwnershipTransferred(address(0), initOwner);
    }
    function owner() public view virtual returns (address) { return _owner; }
    modifier onlyOwner() { require(owner() == msg.sender, "Ownable: not owner"); _; }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

// ── SafeERC20 (minimal) ──
library SafeERC20 {
    bytes4 private constant SIG_TRANSFER   = bytes4(keccak256("transfer(address,uint256)"));
    bytes4 private constant SIG_APPROVE    = bytes4(keccak256("approve(address,uint256)"));

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        (bool ok, bytes memory d) = address(token).call(
            abi.encodeWithSelector(SIG_TRANSFER, to, value)
        );
        require(ok && (d.length == 0 || abi.decode(d, (bool))), "SafeERC20: transfer failed");
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        (bool ok, bytes memory d) = address(token).call(
            abi.encodeWithSelector(SIG_APPROVE, spender, value)
        );
        require(ok && (d.length == 0 || abi.decode(d, (bool))), "SafeERC20: approve failed");
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 newAllowance) internal {
        uint256 current = token.allowance(address(this), spender);
        if (current >= newAllowance) return;

        (bool ok, bytes memory d) = address(token).call(
            abi.encodeWithSelector(SIG_APPROVE, spender, newAllowance)
        );
        if (ok && (d.length == 0 || abi.decode(d, (bool)))) return;

        (ok, d) = address(token).call(
            abi.encodeWithSelector(SIG_APPROVE, spender, 0)
        );
        require(ok && (d.length == 0 || abi.decode(d, (bool))), "SafeERC20: approve reset failed");

        (ok, d) = address(token).call(
            abi.encodeWithSelector(SIG_APPROVE, spender, newAllowance)
        );
        require(ok && (d.length == 0 || abi.decode(d, (bool))), "SafeERC20: approve failed");
    }
}

contract TaxDistributor is Ownable {
    using SafeERC20 for IERC20;

    // ── 配置 ──────────────────────────────────────
    address public token;              // 主代币合约
    address public marketingWallet;
    address public dividendTracker;
    IUniswapV2Router02 public router;
    bool    public autoProcess = true;

    // ── 阈值 ──────────────────────────────────────
    uint256 public minProcessAmount = 1 * 1e18;

    // ── 四项分配比例（bps, 总和 = 10000） ─
    uint256 public marketingBps;      // 营销
    uint256 public burnBps;           // 销毁（直接烧代币，不是烧 BNB！）
    uint256 public lpBps;             // 回流底池
    uint256 public dividendBps;       // 分红
    uint256 public constant MAX_BPS = 10000;

    // ── 调试 ──────────────────────────────
    string  public lastFailureReason;
    uint256 public lastProcessTime;

    // ── 防重入 ────────────────────────────────────
    bool private inProcessing;
    modifier lockProcessing() { inProcessing = true; _; inProcessing = false; }

    // ── 事件 ──────────────────────────────────────
    event FeesProcessed(uint256 tokenAmt, uint256 bnbToMarketing, uint256 bnbToDividend);
    event ProcessFailed(uint256 tokenAmt, string reason);
    event ConfigUpdated(string key, uint256 value);
    event RescueToken(address token, uint256 amount);
    event Debug(string step, uint256 val1, uint256 val2);

    constructor(
        address token_,
        address marketingWallet_,
        address dividendTracker_,
        address router_,
        uint256 _marketingBps,
        uint256 _burnBps,        // ★ 新增：销毁比例
        uint256 _lpBps,
        uint256 _dividendBps
    ) payable Ownable(address(0)) {
        require(_marketingBps + _burnBps + _dividendBps + _lpBps <= MAX_BPS, "TaxDist: BPS overflow");
        require(_marketingBps + _burnBps + _dividendBps + _lpBps == MAX_BPS, "TaxDist: BPS must sum 100%");
        token            = token_;
        marketingWallet  = marketingWallet_;
        dividendTracker  = dividendTracker_;
        router           = IUniswapV2Router02(router_);
        marketingBps = _marketingBps;
        burnBps      = _burnBps;
        dividendBps  = _dividendBps;
        lpBps        = _lpBps;
    }

    // ── 接收 BNB（auto-distribute） ─────────────
    // 当 swap 或其他来源发送 BNB 到本合约时，自动按比例分配。
    receive() external payable {
        uint256 amt = msg.value;
        if (amt == 0) return;

        uint256 totalBps = marketingBps + dividendBps + lpBps + burnBps;
        if (totalBps == 0) return;

        // 只拆分 marketing + dividend（BNB 分配），
        // LP 的 BNB 留在合约内等 doProcess 处理
        // burnBps 的 BNB 不相关（burn 是烧代币，不是烧 BNB）

        uint256 nonLpBurnBps = marketingBps + dividendBps;
        if (nonLpBurnBps == 0) return;

        uint256 forDiv = (amt * dividendBps) / nonLpBurnBps;
        uint256 forMkt = amt - forDiv;

        if (forDiv > 0 && dividendTracker != address(0)) {
            (bool ok,) = payable(dividendTracker).call{value: forDiv}("");
            ok;
        }
        if (forMkt > 0 && marketingWallet != address(0)) {
            (bool ok,) = payable(marketingWallet).call{value: forMkt}("");
            ok;
        }

        if (forDiv > 0 || forMkt > 0) {
            lastProcessTime = block.timestamp;
            emit FeesProcessed(0, forMkt, forDiv);
        }
    }

    // ═══════════════════════════════════════════
    //  核心：处理税费
    // ═══════════════════════════════════════════

    function processFees() external {
        if (inProcessing) return;
        if (!autoProcess && msg.sender != owner()) revert("Not authorized");
        doProcess();
    }

    function forceProcess() external onlyOwner {
        doProcess();
    }

    /**
     * @dev 安全触发 —— 由主合约在 sell 时自动调用。
     *      使用外部 self-call 实现 try/catch，不会 revert 用户交易。
     */
    function tryProcess() external {
        if (inProcessing) return;
        inProcessing = true;
        (bool ok, ) = address(this).call(abi.encodeWithSignature("doProcess()"));
        ok;
        inProcessing = false;
    }

    /**
     * @dev 核心处理逻辑
     *
     *      流程：
     *      1. 烧毁 burnBps 比例的代币
     *      2. LP 部分：一半 swap → BNB + 一半代币 → addLiquidityETH
     *      3. 营销+分红部分：全部 swap → BNB → 分别发送
     */
    function doProcess() public lockProcessing {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance < minProcessAmount) {
            lastFailureReason = "Balance < minProcessAmount";
            return;
        }

        lastFailureReason = "";

        // ═══════════════════════════════════════
        //  1. 销毁 burnBps 部分（直接烧代币）
        // ═══════════════════════════════════════
        uint256 burnAmount = (balance * burnBps) / MAX_BPS;
        uint256 afterBurn = balance - burnAmount;

        if (burnAmount > 0) {
            IERC20(token).safeTransfer(address(0xdead), burnAmount);
        }

        if (afterBurn == 0) {
            lastProcessTime = block.timestamp;
            emit FeesProcessed(balance, 0, 0);
            return;
        }

        // ═══════════════════════════════════════
        //  2. 非 burn 部分按比例拆分
        // ═══════════════════════════════════════
        uint256 nonBurnBps = MAX_BPS - burnBps;  // marketing + lp + dividend

        // LP 部分：代币量
        uint256 lpTokenAmt = (afterBurn * lpBps) / nonBurnBps;
        uint256 nonLpTokenAmt = afterBurn - lpTokenAmt;

        // LP：一半 swap 成 BNB，一半留着加 LP
        uint256 lpSwapAmt  = lpTokenAmt / 2;
        uint256 lpKeepAmt  = lpTokenAmt - lpSwapAmt;

        // 总共需要 swap 的代币 = 营销+分红 全部 + LP的一半
        uint256 swapTotal = nonLpTokenAmt + lpSwapAmt;

        // ═══════════════════════════════════════
        //  3. Swap 代币 → BNB
        // ═══════════════════════════════════════
        IERC20(token).safeIncreaseAllowance(address(router), swapTotal);

        uint256 bnbReceived = _swapTokensForBNB(swapTotal);
        if (bnbReceived == 0) {
            emit ProcessFailed(balance, lastFailureReason);
            return;
        }

        lastProcessTime = block.timestamp;

        // ═══════════════════════════════════════
        //  4. 分配 BNB
        // ═══════════════════════════════════════

        // LP swap 出的 BNB（按比例从总 BNB 中拆分）
        uint256 bnbForLP = (bnbReceived * lpSwapAmt) / swapTotal;
        uint256 bnbForNonLP = bnbReceived - bnbForLP;

        // 营销 + 分红 的 BNB
        uint256 nonLpNonBurnBps = marketingBps + dividendBps;  // marketing + dividend (不含 lp 和 burn)
        uint256 bnbForMarketing = 0;
        uint256 bnbForDividend = 0;

        if (nonLpNonBurnBps > 0 && bnbForNonLP > 0) {
            bnbForDividend  = (bnbForNonLP * dividendBps) / nonLpNonBurnBps;
            bnbForMarketing = bnbForNonLP - bnbForDividend;
        }

        // 发送 BNB
        if (bnbForMarketing > 0 && marketingWallet != address(0)) {
            (bool ok,) = payable(marketingWallet).call{value: bnbForMarketing}("");
            ok;
        }
        if (bnbForDividend > 0 && dividendTracker != address(0)) {
            (bool ok,) = payable(dividendTracker).call{value: bnbForDividend}("");
            ok;
        }

        // ═══════════════════════════════════════
        //  5. 加 LP
        // ═══════════════════════════════════════
        if (lpKeepAmt > 0 && bnbForLP > 0) {
            _addLiquiditySafe(lpKeepAmt, bnbForLP);
        }

        emit FeesProcessed(balance, bnbForMarketing, bnbForDividend);
    }

    /**
     * @dev 执行 token → BNB swap，内部处理失败（不 throw）
     */
    function _swapTokensForBNB(uint256 tokenAmount) internal returns (uint256 bnbAmount) {
        try router.swapExactTokensForETH(
            tokenAmount,
            0,
            _getPath(),
            address(this),
            block.timestamp + 300
        ) returns (uint256[] memory amounts) {
            bnbAmount = amounts[amounts.length - 1];
            if (bnbAmount == 0) {
                lastFailureReason = "Swap output = 0";
                return 0;
            }
            return bnbAmount;
        } catch Error(string memory reason) {
            lastFailureReason = reason;
        } catch {
            lastFailureReason = "Swap failed (unknown)";
        }
    }

    /**
     * @dev 安全加 LP（内部 try/catch，失败不 throw）
     */
    function _addLiquiditySafe(uint256 tokenAmt, uint256 bnbAmt) internal {
        IERC20(token).safeIncreaseAllowance(address(router), tokenAmt);

        try router.addLiquidityETH{value: bnbAmt}(
            token,
            tokenAmt,
            0, 0,
            owner(),
            block.timestamp + 300
        ) {
            emit Debug("lpAddSuccess", tokenAmt, bnbAmt);
        } catch Error(string memory err) {
            lastFailureReason = string(abi.encodePacked("LP: ", err));
            emit Debug("lpAddFail", tokenAmt, bnbAmt);
        } catch {
            lastFailureReason = "LP add failed (unknown)";
            emit Debug("lpAddFail", tokenAmt, bnbAmt);
        }
    }

    function _getPath() internal view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = router.WETH();
        return path;
    }

    // ═══════════════════════════════════════════
    //  Owner 配置
    // ═══════════════════════════════════════════

    function setMarketingWallet(address _wallet) external onlyOwner {
        marketingWallet = _wallet;
        emit ConfigUpdated("marketingWallet", 0);
    }

    function setDividendTracker(address _tracker) external onlyOwner {
        dividendTracker = _tracker;
        emit ConfigUpdated("dividendTracker", 0);
    }

    function setRouter(address _router) external onlyOwner {
        router = IUniswapV2Router02(_router);
        emit ConfigUpdated("router", 0);
    }

    function setToken(address _token) external onlyOwner {
        token = _token;
        emit ConfigUpdated("token", 0);
    }

    /**
     * @dev 设置四项分配比例（bps，必须总和 = 10000）
     */
    function setBps(
        uint256 _marketingBps,
        uint256 _burnBps,
        uint256 _lpBps,
        uint256 _dividendBps
    ) external onlyOwner {
        require(_marketingBps + _burnBps + _dividendBps + _lpBps == MAX_BPS, "BPS must sum 100%");
        marketingBps = _marketingBps;
        burnBps      = _burnBps;
        lpBps        = _lpBps;
        dividendBps  = _dividendBps;
    }

    function setMinProcessAmount(uint256 _amt) external onlyOwner {
        minProcessAmount = _amt;
    }

    function setAutoProcess(bool _on) external onlyOwner {
        autoProcess = _on;
    }

    // ═══════════════════════════════════════════
    //  Emergency withdraw（测试期安全保障）
    // ═══════════════════════════════════════════

    /**
     * @dev 提取任意 ERC20 代币（保留 pending fees）
     */
    function rescueToken(address _token, uint256 _amount) external onlyOwner {
        if (_token == token) {
            uint256 needed = minProcessAmount;
            uint256 bal = IERC20(_token).balanceOf(address(this));
            require(_amount <= bal - needed, "Cannot rescue pending fees");
        }
        IERC20(_token).safeTransfer(owner(), _amount);
        emit RescueToken(_token, _amount);
    }

    /**
     * @dev 提取合约内全部 BNB
     */
    function rescueBNB() external onlyOwner {
        uint256 bal = address(this).balance;
        if (bal > 0) {
            (bool ok,) = payable(owner()).call{value: bal}("");
            require(ok, "BNB transfer failed");
        }
    }

    /**
     * @dev 提取 LP 代币
     */
    function rescueLP(address _pair, uint256 _amount) external onlyOwner {
        IERC20(_pair).safeTransfer(owner(), _amount);
    }

    /**
     * @dev 强制撤除 LP
     */
    function emergencyRemoveLP(address _pair, uint256 _amount) external onlyOwner {
        IERC20(_pair).safeApprove(address(router.factory()), _amount);
        (bool ok,) = address(router).call(
            abi.encodeWithSignature(
                "removeLiquidityETHSupportingFeeOnTransferTokens(address,uint256,uint256,uint256,address,uint256)",
                token, _amount, 0, 0, owner(), block.timestamp
            )
        );
        require(ok, "Remove LP failed");
    }

    /**
     * @dev 查看合约当前状态（调试用）
     */
    function getStatus() external view returns (
        address token_,
        uint256 balance_,
        uint256 minProcessAmount_,
        uint256 marketingBps_,
        uint256 burnBps_,
        uint256 dividendBps_,
        uint256 lpBps_,
        string memory lastFailure_,
        uint256 lastProcessTime_,
        bool autoProcess_
    ) {
        return (
            token,
            IERC20(token).balanceOf(address(this)),
            minProcessAmount,
            marketingBps,
            burnBps,
            dividendBps,
            lpBps,
            lastFailureReason,
            lastProcessTime,
            autoProcess
        );
    }
}
