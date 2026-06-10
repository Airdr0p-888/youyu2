// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ═══════════════════════════════════════════════════════════════
//  ModaMintToken — 仿 USHIT 架构
//
//  核心设计（和 USHIT 一致）：
//  1. 税费代币留在主合约内累积
//  2. 卖出时把合约内累积的代币 swap 成 BNB
//  3. BNB 直达 TaxDistributor（由 receive() 自动按比例分配）
//
//  和 USHIT 的区别：
//  - 不内部分发 BNB（fund/平台/分红），全部发给 TaxDistributor
//  - 使用 ModaDividendTracker（BNB 原生分红，不需要 USDT 中转）
//  - 保留 mint 预售发射逻辑
// ═══════════════════════════════════════════════════════════════

interface IERC20 {
    function decimals() external view returns (uint256);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ISwapRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline
    ) external;
    function addLiquidityETH(
        address token, uint256 amountTokenDesired, uint256 amountTokenMin,
        uint256 amountETHMin, address to, uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}

interface ISwapFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface ISwapPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

// ── Libraries ────────────────────────────────────────────
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) { uint256 c = a + b; require(c >= a, "SafeMath: addition overflow"); return c; }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) { return sub(a, b, "SafeMath: subtraction overflow"); }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b <= a, errorMessage); return a - b; }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) { if (a == 0) return 0; uint256 c = a * b; require(c / a == b, "SafeMath: multiplication overflow"); return c; }
    function div(uint256 a, uint256 b) internal pure returns (uint256) { return div(a, b, "SafeMath: division by zero"); }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b > 0, errorMessage); return a / b; }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) { return mod(a, b, "SafeMath: modulo by zero"); }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { require(b != 0, errorMessage); return a % b; }
}

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;
        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }
    function div(int256 a, int256 b) internal pure returns (int256) { require(b != -1 || a != MIN_INT256); return a / b; }
    function sub(int256 a, int256 b) internal pure returns (int256) { int256 c = a - b; require((b >= 0 && c <= a) || (b < 0 && c > a)); return c; }
    function add(int256 a, int256 b) internal pure returns (int256) { int256 c = a + b; require((b >= 0 && c >= a) || (b < 0 && c < a)); return c; }
    function toUint256Safe(int256 a) internal pure returns (uint256) { require(a >= 0); return uint256(a); }
}

library SafeMathUint {
    function toInt256Safe(uint256 a) internal pure returns (int256) { int256 b = int256(a); require(b >= 0); return b; }
}

library IterableMapping {
    struct Map {
        address[] keys;
        mapping(address => uint256) values;
        mapping(address => uint256) indexOf;
        mapping(address => bool) inserted;
    }
    function get(Map storage map, address key) internal view returns (uint256) { return map.values[key]; }
    function getIndexOfKey(Map storage map, address key) internal view returns (int256) {
        if (!map.inserted[key]) return -1;
        return int256(map.indexOf[key]);
    }
    function size(Map storage map) internal view returns (uint256) { return map.keys.length; }
    function set(Map storage map, address key, uint256 val) internal {
        if (map.inserted[key]) { map.values[key] = val; return; }
        map.inserted[key] = true;
        map.values[key] = val;
        map.indexOf[key] = map.keys.length;
        map.keys.push(key);
    }
    function remove(Map storage map, address key) internal {
        if (!map.inserted[key]) return;
        uint256 idx = map.indexOf[key];
        uint256 lastIdx = map.keys.length - 1;
        if (idx != lastIdx) {
            address lastKey = map.keys[lastIdx];
            map.keys[idx] = lastKey;
            map.indexOf[lastKey] = idx;
        }
        map.keys.pop();
        delete map.inserted[key];
        delete map.values[key];
        delete map.indexOf[key];
    }
}

// ── Ownable ──────────────────────────────────────────────
abstract contract Ownable {
    address internal _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address owner_) {
        address initOwner = owner_ == address(0) ? msg.sender : owner_;
        _owner = initOwner;
        emit OwnershipTransferred(address(0), initOwner);
    }

    function owner() public view returns (address) { return _owner; }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0xdead));
        _owner = address(0xdead);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// ═══════════════════════════════════════════════════════════════
//  DividendPayingToken (abstract, USHIT-style)
// ═══════════════════════════════════════════════════════════════
abstract contract DividendPayingToken is Ownable {
    using SafeMath for uint256;
    using SafeMathUint for uint256;
    using SafeMathInt for int256;

    uint256 internal constant MAGNITUDE = 2 ** 128;
    uint256 internal magnifiedDividendPerShare;
    mapping(address => int256) internal magnifiedDividendCorrections;
    mapping(address => uint256) internal withdrawnDividends;
    uint256 public totalDividendsDistributed;

    event DividendsDistributed(address indexed from, uint256 weiAmount);
    event DividendWithdrawn(address indexed to, uint256 weiAmount);

    constructor() Ownable(msg.sender) {}

    // receive() 自动处理 BNB 分红（不需要 onlyOwner）
    receive() external payable {
        uint256 supply = totalSupply();
        if (supply > 0 && msg.value > 0) {
            magnifiedDividendPerShare = magnifiedDividendPerShare.add(
                msg.value.mul(MAGNITUDE) / supply
            );
            emit DividendsDistributed(msg.sender, msg.value);
            totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
        }
    }

    function distributeBNBDividends(uint256 amount) public virtual onlyOwner {
        uint256 supply = totalSupply();
        require(supply > 0, "DividendPayingToken: supply=0");
        if (amount > 0) {
            magnifiedDividendPerShare = magnifiedDividendPerShare.add(
                amount.mul(MAGNITUDE) / supply
            );
            emit DividendsDistributed(msg.sender, amount);
            totalDividendsDistributed = totalDividendsDistributed.add(amount);
        }
    }

    function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
        uint256 _withdrawableDividend = withdrawableDividendOf(user);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
            emit DividendWithdrawn(user, _withdrawableDividend);
            (bool ok,) = user.call{value: _withdrawableDividend}("");
            if (!ok) {
                withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
                return 0;
            }
            return _withdrawableDividend;
        }
        return 0;
    }

    function withdrawableDividendOf(address _owner) public view returns (uint256) {
        return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
    }

    function withdrawnDividendOf(address _owner) public view returns (uint256) {
        return withdrawnDividends[_owner];
    }

    function accumulativeDividendOf(address _owner) public view returns (uint256) {
        int256 raw = int256(magnifiedDividendPerShare.mul(balanceOf(_owner)) / MAGNITUDE);
        int256 corrected = raw.add(magnifiedDividendCorrections[_owner]);
        return corrected < 0 ? 0 : uint256(corrected);
    }

    function _setBalanceBase(address account, uint256 newBalance) internal {
        uint256 currentBalance = balanceOf(account);
        if (newBalance > currentBalance) {
            uint256 mintAmount = newBalance.sub(currentBalance);
            _mintInternal(account, mintAmount);
        } else if (newBalance < currentBalance) {
            _burnInternal(account, currentBalance.sub(newBalance));
        }
    }

    function _mintInternal(address account, uint256 value) internal virtual {}
    function _burnInternal(address account, uint256 value) internal virtual {}
    function totalSupply() public view virtual returns (uint256) { return 0; }
    function balanceOf(address) public view virtual returns (uint256) { return 0; }
}

// ═══════════════════════════════════════════════════════════════
//  ModaDividendTracker — USHIT-style ETHBackDividendTracker
//  分红使用 BNB（原生），不需要 USDT 中转
// ═══════════════════════════════════════════════════════════════
contract ModaDividendTracker is DividendPayingToken {
    using SafeMath for uint256;
    using SafeMathUint for uint256;
    using SafeMathInt for int256;
    using IterableMapping for IterableMapping.Map;

    IterableMapping.Map private tokenHoldersMap;
    uint256 public lastProcessedIndex;
    mapping(address => bool) public excludedFromDividends;
    mapping(address => uint256) public lastClaimTimes;
    uint256 public claimWait;
    uint256 public minimumTokenBalanceForDividends;
    uint256 private totalTrackedSupply;

    event ExcludeFromDividends(address indexed account, bool excluded);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
    event Claim(address indexed account, uint256 amount, bool indexed automatic);

    constructor(uint256 minBalance_, address owner_) DividendPayingToken() {
        _owner = owner_;
        claimWait = 300;
        minimumTokenBalanceForDividends = minBalance_;
    }

    function totalSupply() public view override returns (uint256) { return totalTrackedSupply; }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenHoldersMap.values[account];
    }

    function _mintInternal(address account, uint256 amount) internal override {
        totalTrackedSupply = totalTrackedSupply.add(amount);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
            .sub((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
    }

    function _burnInternal(address account, uint256 amount) internal override {
        totalTrackedSupply = totalTrackedSupply.sub(amount);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
            .add((magnifiedDividendPerShare.mul(amount)).toInt256Safe());
    }

    function excludeFromDividends(address account, bool excluded) external onlyOwner {
        excludedFromDividends[account] = excluded;
        if (excluded) {
            if (tokenHoldersMap.inserted[account]) {
                _withdrawDividendOfUser(payable(account));
                totalTrackedSupply = totalTrackedSupply.sub(tokenHoldersMap.values[account]);
                tokenHoldersMap.remove(account);
                delete magnifiedDividendCorrections[account];
                delete withdrawnDividends[account];
            }
        }
        emit ExcludeFromDividends(account, excluded);
    }

    function setBalance(address payable account, uint256 newBalance) external onlyOwner {
        if (excludedFromDividends[account]) {
            if (tokenHoldersMap.inserted[account]) {
                totalTrackedSupply = totalTrackedSupply.sub(tokenHoldersMap.values[account]);
                tokenHoldersMap.remove(account);
            }
            return;
        }

        uint256 oldBalance = tokenHoldersMap.inserted[account] ? tokenHoldersMap.values[account] : 0;
        int256 oldCorrection = magnifiedDividendCorrections[account];

        if (newBalance >= minimumTokenBalanceForDividends) {
            if (tokenHoldersMap.inserted[account]) {
                totalTrackedSupply = totalTrackedSupply.sub(oldBalance).add(newBalance);
                tokenHoldersMap.values[account] = newBalance;
            } else {
                tokenHoldersMap.set(account, newBalance);
                totalTrackedSupply = totalTrackedSupply.add(newBalance);
            }

            // 修正：保留历史 correction
            magnifiedDividendCorrections[account] =
                oldCorrection
                .add(int256(magnifiedDividendPerShare.mul(oldBalance) / MAGNITUDE))
                .sub(int256(magnifiedDividendPerShare.mul(newBalance) / MAGNITUDE));
        } else {
            if (tokenHoldersMap.inserted[account]) {
                _withdrawDividendOfUser(payable(account));
                totalTrackedSupply = totalTrackedSupply.sub(oldBalance);
                tokenHoldersMap.remove(account);
                delete magnifiedDividendCorrections[account];
                delete withdrawnDividends[account];
            }
        }
    }

    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
        if (lastClaimTime > block.timestamp) return false;
        return block.timestamp.sub(lastClaimTime) >= claimWait;
    }

    function process(uint256 gas) public returns (uint256, uint256, uint256) {
        uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
        if (numberOfTokenHolders == 0) return (0, 0, lastProcessedIndex);

        uint256 _lastProcessedIndex = lastProcessedIndex;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();
        uint256 iterations = 0;
        uint256 claims = 0;

        while (gasUsed < gas && iterations < numberOfTokenHolders) {
            _lastProcessedIndex++;
            if (_lastProcessedIndex >= tokenHoldersMap.keys.length) _lastProcessedIndex = 0;
            address account = tokenHoldersMap.keys[_lastProcessedIndex];

            if (canAutoClaim(lastClaimTimes[account])) {
                if (processAccount(payable(account), true)) claims++;
            }

            iterations++;
            uint256 newGasLeft = gasleft();
            if (gasLeft > newGasLeft) gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
            gasLeft = newGasLeft;
        }

        lastProcessedIndex = _lastProcessedIndex;
        return (iterations, claims, lastProcessedIndex);
    }

    function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
        uint256 amount = _withdrawDividendOfUser(account);
        if (amount > 0) {
            lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
            return true;
        }
        return false;
    }

    function claim() external {
        require(lastClaimTimes[msg.sender].add(claimWait) <= block.timestamp, "Claim wait not met");
        uint256 amount = withdrawableDividendOf(msg.sender);
        _withdrawDividendOfUser(payable(msg.sender));
        lastClaimTimes[msg.sender] = block.timestamp;
        emit Claim(msg.sender, amount, false);
    }

    function setMinimumTokenBalanceForDividends(uint256 minBalance) external onlyOwner {
        minimumTokenBalanceForDividends = minBalance;
    }

    function setClaimWait(uint256 newClaimWait) external onlyOwner {
        uint256 old = claimWait;
        claimWait = newClaimWait;
        emit ClaimWaitUpdated(newClaimWait, old);
    }

    function getNumberOfTokenHolders() external view returns (uint256) {
        return tokenHoldersMap.keys.length;
    }

    function getTokenHolders(uint256 start, uint256 count_) external view
        returns (address[] memory, uint256[] memory)
    {
        uint256 end = start.add(count_);
        if (end > tokenHoldersMap.keys.length) end = tokenHoldersMap.keys.length;
        if (start >= end) return (new address[](0), new uint256[](0));
        address[] memory addrs = new address[](end.sub(start));
        uint256[] memory balances = new uint256[](end.sub(start));
        for (uint256 i = start; i < end; i = i.add(1)) {
            addrs[i - start] = tokenHoldersMap.keys[i];
            balances[i - start] = tokenHoldersMap.values[tokenHoldersMap.keys[i]];
        }
        return (addrs, balances);
    }

    function emergencyWithdrawBNB() external onlyOwner {
        uint256 bal = address(this).balance;
        if (bal > 0) {
            payable(owner()).transfer(bal);
        }
    }

    function emergencyWithdrawToken(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(owner(), _amount);
    }
}

// ═══════════════════════════════════════════════════════════════
//  ModaMintToken — 主合约（仿 USHIT 架构）
//
//  和 USHIT 一样的核心循环：
//    1. 税费代币留在主合约内
//    2. _transfer 检测到 sell 方向时触发 swap
//    3. swap 后的 BNB 直达 TaxDistributor
//    4. TaxDistributor.receive() 自动按比例分配
// ═══════════════════════════════════════════════════════════════
contract ModaMintToken is IERC20, Ownable {
    using SafeMath for uint256;

    // ── ERC20 状态 ──
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    string private _name;
    string private _symbol;
    uint256 private _tTotal;
    uint256 private constant MAX = ~uint256(0);

    // ── DEX ──
    ISwapRouter public _swapRouter;
    address public currency;                       // WBNB
    address public _mainPair;
    mapping(address => bool) public _swapPairList;

    // ── 防重入 ──
    bool private inSwap;
    modifier lockTheSwap() { inSwap = true; _; inSwap = false; }

    // ── 税费 ──
    uint256 public buyTaxBps;           // 买入总税率（bps）
    uint256 public sellTaxBps;          // 卖出总税率（bps）
    uint256 public burnBps;             // 税费中烧毁比例（10000 = 100%）
    uint256 public constant MAX_TAX = 2500;  // 最高 25%

    // ── 税费分配钱包 ──
    // swap 后的 BNB 直接发到这个地址（TaxDistributor 合约）
    // TaxDistributor.receive() 自动按 marketingBps/dividendBps 分配
    address public taxDistributorWallet;

    // ── 排除列表 ──
    mapping(address => bool) public isExcludedFromTax;

    // ── 分红 ──
    ModaDividendTracker public dividendTracker;

    // ── 交易状态 ──
    bool public tradingActive;
    bool public isAddV2;
    bool public isRemoveV2;

    // ── Mint 预售 ──
    uint256 public mintCostBNB;
    uint256 public tokensPerMint;
    uint256 public tokensPerLP;
    uint256 public lpTokenPct;
    uint256 public fillAmountBNB;
    uint256 public totalBNBCollected;
    mapping(address => uint256) public mintedAmount;
    bool public presaleActive;
    bool public whitelistMintOnly;
    mapping(address => bool) public whitelist;
    uint256 public presaleTokenPct;

    // ── Events ──
    event TradingEnabled();
    event PresaleEnded();
    event Mint(address indexed user, uint256 bnbCost, uint256 tokenAmount);
    event InitialLiquidityAdded(uint256 tokens, uint256 bnb);
    event AddLiquidityFailed(uint256 bnbAmount, string reason);
    event DividendTrackerUpdated(address indexed oldTracker, address indexed newTracker);
    event TaxDistributorWalletSet(address indexed wallet);
    event SwapFailed(uint256 tokenAmount, string reason);

    // ═══════════════════════════════════════════════════════════
    //  Constructor
    //
    //  参数和原来完全一致，内部按 USHIT 模式初始化
    // ═══════════════════════════════════════════════════════════
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        uint256 mintCostBNB_,
        uint256 fillBNB_,
        uint256 buyTax_,
        uint256 sellTax_,
        uint256 marketingPct_,   // ⚠ 传给 TaxDistributor 用的，主合约不存储
        uint256 burnPct_,
        uint256 dividendPct_,    // ⚠ 传给 TaxDistributor 用的
        uint256 liquidityPct_,   // ⚠ 传给 TaxDistributor 用的
        address marketingWallet_,
        uint256 minHoldForDividend_,
        uint256 presaleTokenPct_,
        bool    whitelistMintOnly_,
        uint256 lpTokenPct_
    ) payable Ownable(address(0)) {
        require(buyTax_ <= MAX_TAX, "Buy tax too high");
        require(sellTax_ <= MAX_TAX, "Sell tax too high");
        require(marketingPct_ + burnPct_ + dividendPct_ + liquidityPct_ <= 10000, "Tax alloc > 100%");
        require(fillBNB_ > 0, "Fill must > 0");
        require(mintCostBNB_ > 0, "Mint cost > 0");
        require(fillBNB_ >= mintCostBNB_, "Fill < mint cost");
        require(marketingWallet_ != address(0), "Wallet zero");
        require(presaleTokenPct_ >= 1 && presaleTokenPct_ <= 99, "Presale pct 1-99");
        require(lpTokenPct_ <= 100, "LP pct > 100");

        _name = name_;
        _symbol = symbol_;
        _tTotal = totalSupply_ * 10 ** 18;
        _balances[address(this)] = _tTotal;
        emit Transfer(address(0), address(this), _tTotal);

        // ── DEX 初始化（USHIT 模式） ──
        currency = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;  // WBNB
        ISwapRouter swapRouter = ISwapRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); // PancakeSwap V2
        _swapRouter = swapRouter;
        _allowances[address(this)][address(swapRouter)] = MAX;

        ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
        address swapPair = swapFactory.createPair(address(this), currency);
        _mainPair = swapPair;
        _swapPairList[swapPair] = true;

        // ── 税费 ──
        buyTaxBps = buyTax_;
        sellTaxBps = sellTax_;
        burnBps = burnPct_;

        // ── 排除列表 ──
        isExcludedFromTax[address(this)] = true;
        isExcludedFromTax[owner()] = true;
        isExcludedFromTax[address(swapRouter)] = true;

        // ── Mint 参数 ──
        whitelistMintOnly = whitelistMintOnly_;
        presaleActive = true;
        tradingActive = false;

        mintCostBNB = mintCostBNB_;
        fillAmountBNB = fillBNB_;
        lpTokenPct = lpTokenPct_;
        uint256 mintCount = fillBNB_.div(mintCostBNB_);
        tokensPerMint = _tTotal.mul(presaleTokenPct_) / (100 * mintCount);
        tokensPerLP = tokensPerMint.mul(lpTokenPct_) / 100;
        presaleTokenPct = presaleTokenPct_;

        // ── 分红追踪器（在合约内自动部署，和 USHIT 一样） ──
        uint256 mushHoldNum = _tTotal / 2100;
        dividendTracker = new ModaDividendTracker(mushHoldNum, address(this));

        dividendTracker.excludeFromDividends(address(dividendTracker), true);
        dividendTracker.excludeFromDividends(address(this), true);
        dividendTracker.excludeFromDividends(address(_mainPair), true);
        dividendTracker.excludeFromDividends(address(0xdead), true);
        dividendTracker.excludeFromDividends(address(swapRouter), true);
        dividendTracker.excludeFromDividends(owner(), true);
    }

    // ── ERC20 ─────────────────────────────────────────
    function name() public view returns (string memory) { return _name; }
    function symbol() public view returns (string memory) { return _symbol; }
    function decimals() external pure returns (uint256) { return 18; }
    function totalSupply() public view override returns (uint256) { return _tTotal; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address sender, address spender) public view override returns (uint256) {
        return _allowances[sender][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        if (_allowances[sender][msg.sender] != MAX) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);
        }
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0) && spender != address(0));
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // ═══════════════════════════════════════════════════════════
    //  _isAddLiquidity / _isRemoveLiquidity（USHIT 同款）
    //  用于检测加池/撤池，避免错误地收税或触发 swap
    // ═══════════════════════════════════════════════════════════
    function _isAddLiquidity() internal view returns (bool isAdd) {
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();
        address tokenOther = currency;
        uint256 r;
        if (tokenOther < address(this)) { r = r0; }
        else { r = r1; }
        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isAdd = bal > r;
    }

    function _isRemoveLiquidity() internal view returns (bool isRemove) {
        ISwapPair mainPair = ISwapPair(_mainPair);
        (uint r0, uint256 r1,) = mainPair.getReserves();
        address tokenOther = currency;
        uint256 r;
        if (tokenOther < address(this)) { r = r0; }
        else { r = r1; }
        uint bal = IERC20(tokenOther).balanceOf(address(mainPair));
        isRemove = r >= bal;
    }

    // ═══════════════════════════════════════════════════════════
    //  _transfer — USHIT 式核心循环
    //
    //  流程：
    //   1. 检测加池/撤池
    //   2. 如果是 sell 方向（_swapPairList[to]）→ 触发 swap
    //   3. 收取税费 + 烧毁
    //   4. 更新分红追踪
    //   5. 自动 process 分红
    // ═══════════════════════════════════════════════════════════
    function _transfer(address from, address to, uint256 amount) private {
        uint256 balance = balanceOf(from);
        require(balance >= amount, "balanceNotEnough");

        // ── 检测加池/撤池 ──
        bool isAdd;
        bool isRemove;

        if (_swapPairList[to]) {
            isAdd = _isAddLiquidity();
            isAddV2 = isAdd;
        } else if (_swapPairList[from]) {
            isRemove = _isRemoveLiquidity();
            isRemoveV2 = isRemove;
        }

        // ── DEX 交易处理 ──
        bool takeFee;
        bool isSell;

        if (_swapPairList[from] || _swapPairList[to]) {
            // 交易控制
            if (!tradingActive) {
                bool isExcluded = isExcludedFromTax[from] || isExcludedFromTax[to];
                require(isExcluded, "Trading not active");
            }

            // ★ 卖出时触发 swap（和 USHIT 一样的时机）★
            if (_swapPairList[to]) {
                if (!inSwap && !isAdd) {
                    uint256 contractTokenBalance = balanceOf(address(this));
                    if (contractTokenBalance > 0) {
                        // 限制单次 swap 量，防止 gas 过高
                        uint256 numTokensSellToFund = amount;
                        if (numTokensSellToFund > contractTokenBalance) {
                            numTokensSellToFund = contractTokenBalance;
                        }
                        _swapTaxForDistributor(numTokensSellToFund);
                    }
                }
            }

            if (!isAdd && !isRemove) takeFee = true;

            if (_swapPairList[to]) { isSell = true; }
        }

        // ── 执行转账（收税 + 烧毁） ──
        _tokenTransfer(from, to, amount, takeFee, isSell);

        // ── 更新分红追踪 ──
        try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
        try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}

        // ── 自动 process 分红 ──
        if (!inSwap) {
            uint256 gas = 300000;
            try dividendTracker.process(gas) returns (
                uint256 iterations, uint256 claims, uint256 lastProcessedIndex
            ) {
                // 静默成功
            } catch {}
        }
    }

    // ═══════════════════════════════════════════════════════════
    //  _tokenTransfer — 分离税费和烧毁
    //
    //  USHIT-style：税费进合约、烧毁进 dead，rest 给接收方。
    //  burnBps 是占税费的百分比（不是交易量的百分比）。
    // ═══════════════════════════════════════════════════════════
    function _tokenTransfer(
        address sender, address recipient, uint256 tAmount, bool takeFee, bool isSell
    ) private {
        _balances[sender] = _balances[sender].sub(tAmount);
        uint256 feeAmount;

        if (takeFee) {
            uint256 taxBps = isSell ? sellTaxBps : buyTaxBps;
            uint256 taxAmount = tAmount.mul(taxBps) / 10000;

            if (taxAmount > 0) {
                // 烧毁部分（burnBps 是税费分配中的比例）
                uint256 burnAmount = taxAmount.mul(burnBps) / 10000;
                if (burnAmount > 0) {
                    feeAmount = feeAmount.add(burnAmount);
                    _takeTransfer(sender, address(0xdead), burnAmount);
                }
                // 其余税费留在合约内
                uint256 contractAmt = taxAmount.sub(burnAmount);
                if (contractAmt > 0) {
                    feeAmount = feeAmount.add(contractAmt);
                    _takeTransfer(sender, address(this), contractAmt);
                }
            }
        }

        _takeTransfer(sender, recipient, tAmount.sub(feeAmount));
    }

    function _takeTransfer(address sender, address to, uint256 tAmount) private {
        _balances[to] = _balances[to].add(tAmount);
        emit Transfer(sender, to, tAmount);
    }

    // ═══════════════════════════════════════════════════════════
    //  _swapTaxForDistributor
    //
    //  和 USHIT 的 swapTokenForFund 一样的定位，但逻辑更简单：
    //    - 合约内累积的代币 → BNB → 直接发到 TaxDistributor
    //    - 不需要 TokenDistributor 中转
    //    - 不需要内部分配（fund/平台/分红）
    //    - TaxDistributor.receive() 自动拆给 marketing + dividend
    // ═══════════════════════════════════════════════════════════
    event FailedSwapExactTokensForETH();

    function _swapTaxForDistributor(uint256 tokenAmount) private lockTheSwap {
        if (tokenAmount == 0) return;
        if (taxDistributorWallet == address(0)) return;
        if (_balances[address(this)] < tokenAmount) return;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = currency;

        // 确保 Router 有足够授权
        _approve(address(this), address(_swapRouter), tokenAmount);

        try _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,                         // amountOutMin = 0，接受任何输出
            path,
            taxDistributorWallet,      // ★ BNB 直达分配合约
            block.timestamp
        ) {
            // BNB 已直达 taxDistributorWallet
            // TaxDistributor.receive() 自动按比例分配
        } catch {
            emit FailedSwapExactTokensForETH();
        }
    }

    // ═══════════════════════════════════════════════════════════
    //  手动触发 swap（Owner 兜底）
    // ═══════════════════════════════════════════════════════════
    function forceSwapTax() external onlyOwner lockTheSwap {
        require(taxDistributorWallet != address(0), "Distributor wallet not set");
        uint256 tokenBal = balanceOf(address(this));
        if (tokenBal > 0) {
            _swapTaxForDistributor(tokenBal);
        }
    }

    // ═══════════════════════════════════════════════════════════
    //  设置税费分配钱包
    //  发射时 launch.html 自动调用，不需要手动操作
    // ═══════════════════════════════════════════════════════════
    function setTaxDistributorWallet(address _wallet) external onlyOwner {
        require(_wallet != address(0), "Zero address");
        taxDistributorWallet = _wallet;
        isExcludedFromTax[_wallet] = true;
        emit TaxDistributorWalletSet(_wallet);
    }

    // ═══════════════════════════════════════════════════════════
    //  receive() — Mint 预售（USHIT 也是用 receive 做 mint）
    // ═══════════════════════════════════════════════════════════
    receive() external payable {
        if (presaleActive && msg.value == mintCostBNB && !inSwap) {
            _mint();
        }
    }

    // ── mint（内部函数） ──
    function _mint() internal {
        require(presaleActive, "Presale not active");
        require(msg.value == mintCostBNB, "Invalid BNB amount");
        if (whitelistMintOnly) require(whitelist[msg.sender], "Not whitelisted");
        require(totalBNBCollected + msg.value <= fillAmountBNB, "Presale full");

        totalBNBCollected = totalBNBCollected.add(msg.value);
        uint256 tokenAmt = tokensPerMint;
        require(_balances[address(this)] >= tokenAmt.add(tokensPerLP), "Insufficient contract balance");

        _balances[msg.sender] = _balances[msg.sender].add(tokenAmt);
        _balances[address(this)] = _balances[address(this)].sub(tokenAmt);
        mintedAmount[msg.sender] = mintedAmount[msg.sender].add(tokenAmt);

        emit Transfer(address(this), msg.sender, tokenAmt);
        emit Mint(msg.sender, msg.value, tokenAmt);

        // 更新分红追踪
        try dividendTracker.setBalance(payable(msg.sender), balanceOf(msg.sender)) {} catch {}

        // 加 LP
        if (tokensPerLP > 0) {
            _addMintLiquidity(msg.value);
        }

        // 预售完成 → 自动开盘
        if (totalBNBCollected >= fillAmountBNB) {
            presaleActive = false;
            tradingActive = true;
            emit PresaleEnded();
            emit TradingEnabled();
        }
    }

    function _addMintLiquidity(uint256 bnbAmount) internal {
        uint256 tokenForLP = tokensPerLP;
        _approve(address(this), address(_swapRouter), tokenForLP);
        try _swapRouter.addLiquidityETH{value: bnbAmount}(
            address(this), tokenForLP, 0, 0, owner(), block.timestamp + 300
        ) returns (uint256 tokenUsed, uint256 bnbUsed, uint256 liquidity) {
            emit InitialLiquidityAdded(tokenUsed, bnbUsed);
        } catch Error(string memory reason) {
            emit AddLiquidityFailed(bnbAmount, reason);
        } catch {
            emit AddLiquidityFailed(bnbAmount, "AddLiquidityFailed");
        }
    }

    // ═══════════════════════════════════════════════════════════
    //  Admin 管理
    // ═══════════════════════════════════════════════════════════
    function setBuyTax(uint256 bps) external onlyOwner { require(bps <= MAX_TAX); buyTaxBps = bps; }
    function setSellTax(uint256 bps) external onlyOwner { require(bps <= MAX_TAX); sellTaxBps = bps; }
    function setBurnBps(uint256 bps) external onlyOwner { burnBps = bps; }
    function excludeFromTax(address a, bool ex) external onlyOwner { isExcludedFromTax[a] = ex; }

    function enableTrading() external onlyOwner {
        require(!tradingActive, "Already active");
        tradingActive = true;
        emit TradingEnabled();
    }

    // ── Mint 管理 ──
    function setMintPrice(uint256 costBNB_, uint256 fillBNB_) external onlyOwner {
        require(costBNB_ > 0 && fillBNB_ >= costBNB_, "Invalid params");
        mintCostBNB = costBNB_;
        fillAmountBNB = fillBNB_;
        uint256 mintCount = fillBNB_.div(costBNB_);
        tokensPerMint = _tTotal.mul(presaleTokenPct) / (100 * mintCount);
        tokensPerLP = tokensPerMint.mul(lpTokenPct) / 100;
    }

    function addWhitelist(address[] calldata users) external onlyOwner {
        for (uint i = 0; i < users.length; i = i.add(1)) whitelist[users[i]] = true;
    }
    function removeWhitelist(address[] calldata users) external onlyOwner {
        for (uint i = 0; i < users.length; i = i.add(1)) whitelist[users[i]] = false;
    }
    function setWhitelistMintOnly(bool v) external onlyOwner { whitelistMintOnly = v; }

    // ── 前端兼容别名 ──
    function mintPrice()      external view returns (uint256) { return mintCostBNB; }
    function hardCap()        external view returns (uint256) { return fillAmountBNB; }
    function totalMinted()    external view returns (uint256) { return totalBNBCollected; }
    function tradingEnabled() external view returns (bool)   { return tradingActive; }
    function openMode()       external pure returns (uint8)   { return 0; }
    function whitelistOnly()  external view returns (bool)   { return whitelistMintOnly; }
    function hasMinted(address user) external view returns (bool) { return mintedAmount[user] > 0; }
    function mintBatchSize()  external view returns (uint256) { return mintCostBNB; }

    // ── LP 管理 ──
    function addLiquidityWithBNB(uint256 tokenAmount) external payable onlyOwner {
        require(msg.value > 0, "Send BNB");
        require(tokenAmount > 0, "Token amount > 0");
        require(_balances[address(this)] >= tokenAmount, "Insufficient tokens");
        _approve(address(this), address(_swapRouter), tokenAmount);
        _swapRouter.addLiquidityETH{value: msg.value}(
            address(this), tokenAmount, 0, 0, owner(), block.timestamp + 300
        );
    }

    function withdrawBNB() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function emergencyWithdrawToken(address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner(), amount);
    }

    // ── 分红管理 ──
    function setDividendTracker(ModaDividendTracker newTracker) external onlyOwner {
        emit DividendTrackerUpdated(address(dividendTracker), address(newTracker));
        dividendTracker = newTracker;
    }

    function triggerDividendProcess(uint256 gas) external onlyOwner {
        dividendTracker.process(gas);
    }

    function claimDividend() external {
        dividendTracker.processAccount(payable(msg.sender), false);
    }

    function setDividendClaimWait(uint256 wait_) external onlyOwner {
        dividendTracker.setClaimWait(wait_);
    }

    function setMinHoldForDividend(uint256 amt) external onlyOwner {
        dividendTracker.setMinimumTokenBalanceForDividends(amt);
    }

    function excludeFromDividend(address account, bool excluded) external onlyOwner {
        dividendTracker.excludeFromDividends(account, excluded);
    }

    function dividendTrackerEmergencyWithdrawBNB() external onlyOwner {
        dividendTracker.emergencyWithdrawBNB();
    }

    function dividendTrackerEmergencyWithdrawToken(address _token, uint256 _amount) external onlyOwner {
        dividendTracker.emergencyWithdrawToken(_token, _amount);
    }
}
