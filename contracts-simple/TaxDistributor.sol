// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ── Interfaces (inline, no external deps) ──
interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
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
    bytes4 private constant SIG_ALLOWANCE  = bytes4(keccak256("allowance(address,address)"));

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

    /**
     * @dev 安全设置授权额度，兼容 USDT 等"必须先置0再设新值"的代币。
     *      策略：1) 先检查当前授权是否足够；2) 尝试直接设新值；3) 若失败，先置0再设新值。
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 newAllowance) internal {
        // 读取当前授权额度
        uint256 current = token.allowance(address(this), spender);
        if (current >= newAllowance) return; // 已经足够，不用再授权

        // 尝试直接设置新值（大多数代币支持）
        (bool ok, bytes memory d) = address(token).call(
            abi.encodeWithSelector(SIG_APPROVE, spender, newAllowance)
        );
        if (ok && (d.length == 0 || abi.decode(d, (bool)))) return;

        // 失败：先置 0 再设新值（兼容 USDT）
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

/**
 * @title TaxDistributor
 * @dev 独立税费处理合约，负责：
 *   - 接收主合约转来的税费代币
 *   - swap 代币 → BNB
 *   - 分配 BNB 给营销钱包 / 分红合约
 *   - 可选：用部分代币+BNB 加流动性（LP 发给 owner）
 *
 * 主合约只负责交易和收税，把税费代币 transfer 给本合约，
 * 本合约异步处理，用户的交易永远不会因 swap 失败而 revert。
 */
contract TaxDistributor is Ownable {
    using SafeERC20 for IERC20;

    // ── 配置 ──────────────────────────────────────
    address public token;           // 主代币合约
    address public marketingWallet;
    address public dividendTracker;
    IUniswapV2Router02 public router;
    bool    public autoProcess = true;   // 是否允许任何人触发 processFees

    // ── 阈值 ──────────────────────────────────────
    uint256 public minProcessAmount = 1 * 1e18;  // 至少累积多少代币才处理

    // ── 分配比例（basis points, 10000 = 100%） ─
    uint256 public marketingBps = 5000;  // 50% → 营销
    uint256 public dividendBps  = 5000;  // 50% → 分红
    uint256 public lpBps         = 0;     // 0%  → 不加 LP（可按需开启）
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
        uint256 _dividendBps,
        uint256 _lpBps
    ) payable Ownable(address(0)) {
        require(_marketingBps + _dividendBps + _lpBps <= MAX_BPS, "TaxDist: BPS overflow");
        token           = token_;
        marketingWallet = marketingWallet_;
        dividendTracker = dividendTracker_;
        router          = IUniswapV2Router02(router_);
        marketingBps = _marketingBps;
        dividendBps  = _dividendBps;
        lpBps        = _lpBps;
    }

    // ── 接收 BNB（来自 swap） ───────────────────
    receive() external payable {}

    // ═══════════════════════════════════════════
    // 核心：处理税费
    // ═══════════════════════════════════════════

    /**
     * @dev 任何人都可以调用（如果 autoProcess = true），
     *      或仅 owner 调用。
     *      把合约内累积的代币 swap 成 BNB 并分配。
     */
    function processFees() external {
        if (inProcessing) return;
        if (!autoProcess && msg.sender != owner()) revert("Not authorized");
        doProcess();
    }

    /**
     * @dev owner 强制处理（忽略 autoProcess 开关）
     */
    function forceProcess() external onlyOwner {
        doProcess();
    }

    /**
     * @dev 安全触发 —— 永不 revert。
     *      供主合约 _handleTax 自动调用，也供任何人手动触发。
     *      如果 swap 失败，错误被静默吞掉，不会影响用户交易。
     */
    function tryProcess() external {
        try this.doProcess() {} catch {}
    }

    function doProcess() public lockProcessing {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance < minProcessAmount) { lastFailureReason = "Balance < minProcessAmount"; return; }
        emit Debug("start", balance, minProcessAmount);
        lastFailureReason = "";

        // ── 计算各部分数量 ────────────────────────
        // 总额拆分：lpBps 部分用于加池，其余用于 swap 成 BNB 分配
        uint256 lpTokenAmt  = (balance * lpBps) / MAX_BPS;
        uint256 shareTokenAmt = balance - lpTokenAmt;   // 营销+分红部分（不用于加池）

        // LP 部分：一半 swap 成 BNB，一半保留代币，用于 addLiquidityETH
        uint256 lpKeepToken = lpTokenAmt / 2;            // 保留的一半（向下取整）
        uint256 lpSwapAmt  = lpTokenAmt - lpKeepToken;   // 需要 swap 成 BNB 的一半

        // 总共需要多少代币 swap 成 BNB
        uint256 swapTotal = shareTokenAmt + lpSwapAmt;

        if (swapTotal == 0) {
            // 全部是 LP 代币，且 lpTokenAmt <= 1（此时 lpKeepToken = 0）
            // 不足以加池，直接返回
            lastFailureReason = "LP amount too small to add liquidity";
            return;
        }

        // ── Approve router（安全增量授权）──────────────────────
        IERC20(token).safeIncreaseAllowance(address(router), swapTotal);

        // ── Swap → BNB ──────────────────────────
        uint256 bnbBefore = address(this).balance;
        emit Debug("swapping", swapTotal, bnbBefore);

        try router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            swapTotal,
            1,               // amountOutMin = 1 wei，拒绝零输出
            _getPath(),
            address(this),
            block.timestamp + 300   // 5 分钟过期
        ) {
            uint256 bnbReceived = address(this).balance - bnbBefore;
            if (bnbReceived == 0) { revert("Swap output = 0"); }

            emit Debug("swapSuccess", bnbReceived, 0);
            lastProcessTime = block.timestamp;
            lastFailureReason = "";

            // ── 按 swap 比例拆分 BNB ─────────────────
            // swapTotal 中 lpSwapAmt 部分得到的 BNB 用于加 LP
            uint256 bnbFromLpSwap = (bnbReceived * lpSwapAmt) / swapTotal;
            uint256 bnbFromShare   = bnbReceived - bnbFromLpSwap;

            // ── 分配营销+分红 BNB ─────────────────────
            uint256 nonLpBps = MAX_BPS - lpBps; // marketingBps + dividendBps
            uint256 bnbForMarketing;
            uint256 bnbForDividend;

            if (nonLpBps > 0) {
                bnbForMarketing  = (bnbFromShare * marketingBps) / nonLpBps;
                bnbForDividend = bnbFromShare - bnbForMarketing;
            }
            // 如果 nonLpBps == 0（lpBps=10000），bnbFromShare 应该为 0

            if (bnbForMarketing > 0 && marketingWallet != address(0)) {
                (bool ok, ) = payable(marketingWallet).call{value: bnbForMarketing}("");
                if (!ok) { /* 不 revert，继续 */ }
            }

            if (bnbForDividend > 0 && dividendTracker != address(0)) {
                (bool ok, ) = payable(dividendTracker).call{value: bnbForDividend}("");
                if (!ok) { /* 不 revert，继续 */ }
            }

            // ── 加 LP ──────────────────────────
            if (lpKeepToken > 0 && bnbFromLpSwap > 0) {
                _addLiquidity(lpKeepToken, bnbFromLpSwap);
            }

            emit FeesProcessed(balance, bnbForMarketing, bnbForDividend);

        } catch Error(string memory reason) {
            lastFailureReason = reason;
            emit Debug("failed", 0, 0);
            emit ProcessFailed(balance, reason);
            return;
        } catch {
            lastFailureReason = "Swap failed (unknown)";
            emit Debug("failed", 0, 0);
            emit ProcessFailed(balance, "Swap failed");
            return;
        }
    }

    function _addLiquidity(uint256 tokenAmt, uint256 bnbAmt) internal {
        if (tokenAmt == 0) return;
        // 使用安全增量授权，避免某些代币不支持先0再非零
        IERC20(token).safeIncreaseAllowance(address(router), tokenAmt);

        try router.addLiquidityETH{value: bnbAmt}(
            token,
            tokenAmt,
            0, 0,
            owner(),        // ← LP 发给 owner（部署者），防止卡死！
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
    // Owner 配置
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

    function setBps(uint256 _marketingBps, uint256 _dividendBps, uint256 _lpBps) external onlyOwner {
        require(_marketingBps + _dividendBps + _lpBps <= MAX_BPS, "BPS overflow");
        marketingBps = _marketingBps;
        dividendBps  = _dividendBps;
        lpBps         = _lpBps;
    }

    function setMinProcessAmount(uint256 _amt) external onlyOwner {
        minProcessAmount = _amt;
    }

    function setAutoProcess(bool _on) external onlyOwner {
        autoProcess = _on;
    }

    // ═══════════════════════════════════════════
    // 救援函数（防止代币卡死）
    // ═══════════════════════════════════════════

    /**
     * @dev 提取任意 ERC20 代币（包括本币、LP 等）
     *      防止代币意外转入后无法取出。
     */
    function rescueToken(address _token, uint256 _amount) external onlyOwner {
        if (_token == token) {
            // 本币：只提取「超出待处理」的部分，不影响正常流程
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
        (bool ok, ) = payable(owner()).call{value: bal}("");
        require(ok, "BNB transfer failed");
    }

    /**
     * @dev 提取 LP 代币（Pancake Pair）
     *      LP 发给 owner，不影响底池。
     */
    function rescueLP(address _pair, uint256 _amount) external onlyOwner {
        IERC20(_pair).safeTransfer(owner(), _amount);
    }

    /**
     * @dev 强制撤除 LP（销毁 LP 取回代币 + BNB）
     *      仅在紧急情况下使用。
     */
    function emergencyRemoveLP(address _pair, uint256 _amount) external onlyOwner {
        IERC20(_pair).safeApprove(router.factory(), _amount);
        (bool ok, ) = address(router).call(
            abi.encodeWithSignature(
                "removeLiquidityETHSupportingFeeOnTransferTokens(address,uint256,uint256,uint256,address,uint256)",
                token, _amount, 0, 0, owner(), block.timestamp
            )
        );
        require(ok, "Remove LP failed");
    }

    /**
     * @dev 查看合约当前状态（调试用）
     *     调用后在 BscScan 上直接看到所有关键信息。
     */
    function getStatus() external view returns (
        address token_,
        uint256 balance_,
        uint256 minProcessAmount_,
        uint256 marketingBps_,
        uint256 dividendBps_,
        uint256 lpBps_,
        string memory lastFailure_,
        uint256 lastProcessTime_
    ) {
        return (
            token,
            IERC20(token).balanceOf(address(this)),
            minProcessAmount,
            marketingBps,
            dividendBps,
            lpBps,
            lastFailureReason,
            lastProcessTime
        );
    }
}
