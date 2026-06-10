// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
        require(newOwner != address(0), "zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

contract TaxDistributorBNB is Ownable {
    address public marketingWallet;
    address public dividendTracker;

    uint256 public marketingBps;
    uint256 public dividendBps;
    uint256 public constant MAX_BPS = 10000;

    event BnbDistributed(uint256 total, uint256 marketShare, uint256 divShare);

    receive() external payable {}

    constructor(
        address _marketing,
        address _dividend,
        uint256 _marketBps,
        uint256 _divBps,
        address owner_
    ) Ownable(owner_) {
        require(_marketBps + _divBps <= MAX_BPS, "bps overflow");
        marketingWallet = _marketing;
        dividendTracker = _dividend;
        marketingBps = _marketBps;
        dividendBps = _divBps;
    }

    // 任何人一键分发全部BNB
    function distributeBNB() external {
        uint256 total = address(this).balance;
        if(total == 0) return;

        uint256 marketAmt = (total * marketingBps) / MAX_BPS;
        uint256 divAmt = total - marketAmt;

        if(marketAmt > 0 && marketingWallet != address(0)) {
            (bool ok, ) = payable(marketingWallet).call{value: marketAmt}("");
            ok;
        }
        if(divAmt > 0 && dividendTracker != address(0)) {
            (bool ok, ) = payable(dividendTracker).call{value: divAmt}("");
            ok;
        }
        emit BnbDistributed(total, marketAmt, divAmt);
    }

    // 修改分配比例
    function setBps(uint256 mBps, uint256 dBps) external onlyOwner {
        require(mBps + dBps <= MAX_BPS, "bps overflow");
        marketingBps = mBps;
        dividendBps = dBps;
    }

    // 修改接收钱包
    function setWallets(address market, address div) external onlyOwner {
        marketingWallet = market;
        dividendTracker = div;
    }

    // 紧急提取全部BNB
    function rescueAllBNB() external onlyOwner {
        uint256 bal = address(this).balance;
        (bool ok, ) = payable(owner()).call{value: bal}("");
        require(ok, "bnb withdraw fail");
    }
}
