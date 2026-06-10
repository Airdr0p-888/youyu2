// Auto-generated — DO NOT EDIT
var CONTRACT_DATA = {
  ABI: [
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "name_",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "symbol_",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "totalSupply_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "mintCostBNB_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "fillBNB_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "buyTax_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "sellTax_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "marketingPct_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "burnPct_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "dividendPct_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "liquidityPct_",
        "type": "uint256"
      },
      {
        "internalType": "address",
        "name": "marketingWallet_",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "minHoldForDividend_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "presaleTokenPct_",
        "type": "uint256"
      },
      {
        "internalType": "bool",
        "name": "whitelistMintOnly_",
        "type": "bool"
      },
      {
        "internalType": "uint256",
        "name": "lpTokenPct_",
        "type": "uint256"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "owner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "spender",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "value",
        "type": "uint256"
      }
    ],
    "name": "Approval",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "holder",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "DividendClaimed",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "tokensSwapped",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "dividendReceived",
        "type": "uint256"
      }
    ],
    "name": "DividendProcessed",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "oldTracker",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newTracker",
        "type": "address"
      }
    ],
    "name": "DividendTrackerUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "tokens",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "bnb",
        "type": "uint256"
      }
    ],
    "name": "InitialLiquidityAdded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "user",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "bnbCost",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "tokenAmount",
        "type": "uint256"
      }
    ],
    "name": "Mint",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [],
    "name": "PresaleEnded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "oldDistributor",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newDistributor",
        "type": "address"
      }
    ],
    "name": "TaxDistributorUpdated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [],
    "name": "TradingEnabled",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "from",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "to",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "value",
        "type": "uint256"
      }
    ],
    "name": "Transfer",
    "type": "event"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "tokenAmount",
        "type": "uint256"
      }
    ],
    "name": "addLiquidityWithBNB",
    "outputs": [],
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address[]",
        "name": "users",
        "type": "address[]"
      }
    ],
    "name": "addWhitelist",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "a",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "spender",
        "type": "address"
      }
    ],
    "name": "allowance",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "spender",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "approve",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "a",
        "type": "address"
      }
    ],
    "name": "balanceOf",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "burnBps",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "buyTaxBps",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "claimDividend",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "decimals",
    "outputs": [
      {
        "internalType": "uint8",
        "name": "",
        "type": "uint8"
      }
    ],
    "stateMutability": "pure",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "dividendBps",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "dividendTracker",
    "outputs": [
      {
        "internalType": "contract ModaDividendTracker",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "dividendTrackerEmergencyWithdrawBNB",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "token",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "emergencyWithdrawToken",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "enableTrading",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "account",
        "type": "address"
      },
      {
        "internalType": "bool",
        "name": "excluded",
        "type": "bool"
      }
    ],
    "name": "excludeFromDividend",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "a",
        "type": "address"
      },
      {
        "internalType": "bool",
        "name": "ex",
        "type": "bool"
      }
    ],
    "name": "excludeFromTax",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "fillAmountBNB",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "forwardTaxTokens",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "hardCap",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "user",
        "type": "address"
      }
    ],
    "name": "hasMinted",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "isExcludedFromTax",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "liquidityBps",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "lpTokenPct",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "marketingBps",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "marketingWallet",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "mint",
    "outputs": [],
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "mintBatchSize",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "mintCostBNB",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "mintPrice",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "mintedAmount",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "name",
    "outputs": [
      {
        "internalType": "string",
        "name": "",
        "type": "string"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "openMode",
    "outputs": [
      {
        "internalType": "uint8",
        "name": "",
        "type": "uint8"
      }
    ],
    "stateMutability": "pure",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "presaleActive",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "presaleTokenPct",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "lpAmount",
        "type": "uint256"
      }
    ],
    "name": "removeLiquidity",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address[]",
        "name": "users",
        "type": "address[]"
      }
    ],
    "name": "removeWhitelist",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "sellTaxBps",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "bps",
        "type": "uint256"
      }
    ],
    "name": "setBurnBps",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "bps",
        "type": "uint256"
      }
    ],
    "name": "setBuyTax",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "bps",
        "type": "uint256"
      }
    ],
    "name": "setDividendBps",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "wait_",
        "type": "uint256"
      }
    ],
    "name": "setDividendClaimWait",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "contract ModaDividendTracker",
        "name": "newTracker",
        "type": "address"
      }
    ],
    "name": "setDividendTracker",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "bps",
        "type": "uint256"
      }
    ],
    "name": "setLiquidityBps",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "bps",
        "type": "uint256"
      }
    ],
    "name": "setMarketingBps",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "w",
        "type": "address"
      }
    ],
    "name": "setMarketingWallet",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "amt",
        "type": "uint256"
      }
    ],
    "name": "setMinHoldForDividend",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "costBNB_",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "fillBNB_",
        "type": "uint256"
      }
    ],
    "name": "setMintPrice",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "bps",
        "type": "uint256"
      }
    ],
    "name": "setSellTax",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_dist",
        "type": "address"
      }
    ],
    "name": "setTaxDistributor",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "bool",
        "name": "v",
        "type": "bool"
      }
    ],
    "name": "setWhitelistMintOnly",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "symbol",
    "outputs": [
      {
        "internalType": "string",
        "name": "",
        "type": "string"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "taxDistributor",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "tokensPerLP",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "tokensPerMint",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalBNBCollected",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalMinted",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "totalSupply",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "tradingActive",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "tradingEnabled",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "to",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "transfer",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "from",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "to",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "transferFrom",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "gas",
        "type": "uint256"
      }
    ],
    "name": "triggerDividendProcess",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "uniswapV2Pair",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "uniswapV2Router",
    "outputs": [
      {
        "internalType": "contract IUniswapV2Router02",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "whitelist",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "whitelistMintOnly",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "whitelistOnly",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "withdrawBNB",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "withdrawLP",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "stateMutability": "payable",
    "type": "receive"
  }
],
  BYTECODE: "0x6101408060405234620006985760006101005262004dce803803809162000027828562000c32565b833981019061020081830312620006f85780516001600160401b038111620006f857826200005791830162000c56565b602082015190926001600160401b038211620006f8576200007a91830162000c56565b9060408101516060820151608052608082015160c05260a082015160c083015160e084015191610100850151936101208601519561014081015197620000c4610160830162000ccd565b99610180830151926101a081015160e0526101c0810151806101205280151503620006f8576101e0015160a0526101005180546001600160a01b031916339081178255604051917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08180a36109c49081871162000bd35750861162000b9a57612710620001628b6200015c8c6200015c8d8d62000ce2565b62000ce2565b1162000b625760c0511562000b2d576080511562000af85760805160c0511062000ac0576001600160a01b038b161562000a8d5760e0516001811015908162000a80575b501562000a4857606460a0511162000a14578051906001600160401b038211620009135760015461010051600182811c9216801562000a09575b6020831014620008f057509081601f849311620009ad575b506101005190602091601f841160011462000939575061010051926200092d575b50508160011b916000199060031b1c1916176001555b8051906001600160401b038211620009135760025461010051600182811c9216801562000908575b6020831014620008f057509081601f84931162000894575b506101005190602091601f8411600114620008205750610100519262000814575b50508160011b916000199060031b1c1916176002555b670de0b6b3a764000082818102048114831517156200069d5780830260035530610100515260046020526101005192026040832055604051918261155081011060018060401b0361155085011117620007fc57506115506200387e833961155082019081523060208201526101005191908190036040019082f0908115620007f0575060018060a01b031660018060a01b0319601a541617601a55600655600755600855600955600b55600a5560018060a01b03811660018060a01b0319600c541617600c557310ed43c718714eb63d5aa57b78b54704e256024e60018060a01b0319600d541617600d5560405163c45a015560e01b81526020816004817310ed43c718714eb63d5aa57b78b54704e256024e5afa908115620006d1576101005191620007ae575b506040516315ab88c960e31b81526020816004817310ed43c718714eb63d5aa57b78b54704e256024e5afa8015620006d15761010051906200076c575b6040516364e329cb60e11b81523060048201526001600160a01b03918216602482015261010051909360209350849260449284929091165af1908115620006d15761010051916200072a575b50600e80546001600160a01b0319166001600160a01b039283161790556101008051309052600f60205280516040808220805460ff1990811660019081179092558354861690935283518281208054851683179055958516909552825181812080548416871790557310ed43c718714eb63d5aa57b78b54704e256024e905291519182208054909116909317909255601a541690813b15620006ce575060405162241fbd60e51b9182825230600483015260016024830152816044816101005180945af18015620006d15762000718575b50601a546001600160a01b0316803b15620006f8576040519082825261010051600483015260016024830152816044816101005180945af18015620006d157620006ff575b50601a54600e546001600160a01b039081169116803b15620006f85760405191838352600483015260016024830152816044816101005180945af18015620006d157620006df575b50601a546101005180546001600160a01b03928316921690823b15620006ce5750604051928352600483015260016024830152816044816101005180945af18015620006d157620006b7575b50600160175461ff0061012051151560081b169061ffff1916171760175560ff60a01b19600e5416600e556080518060105560c0518060145560a051601355046200065160e05160035462000d06565b816064029160648304036200069d57811562000698576064916200067e91048060115560a0519062000d06565b0460125560e051601955604051612b63908162000d1b8239f35b600080fd5b634e487b7160e01b61010051526011600452602461010051fd5b620006c29062000c08565b61010051801562000601575b80fd5b6040513d61010051823e3d90fd5b620006ea9062000c08565b610100518015620005b55780fd5b6101005180fd5b6200070a9062000c08565b6101005180156200056d5780fd5b620007239062000c08565b3862000528565b90506020813d60201162000763575b81620007486020938362000c32565b81010312620006f8576200075c9062000ccd565b3862000457565b3d915062000739565b506020813d602011620007a5575b81620007896020938362000c32565b81010312620006f8576200079f60209162000ccd565b6200040b565b3d91506200077a565b90506020813d602011620007e7575b81620007cc6020938362000c32565b81010312620006f857620007e09062000ccd565b38620003ce565b3d9150620007bd565b604051903d90823e3d90fd5b634e487b7160e01b9052604160045261010051602490fd5b01519050388062000290565b60029194505261010051906020822091935b601f198416851062000878576001945083601f198116106200085e575b505050811b01600255620002a6565b015160001960f88460031b161c191690553880806200084f565b8181015183556020948501946001909301929091019062000832565b909150600261010051526101005160208120601f850160051c810160208610620008e8575b9085949392915b601f840160051c82018110620008d9575050506200026f565b828155869550600101620008c0565b5080620008b9565b634e487b7160e01b9052602260045261010051602490fd5b91607f169162000257565b634e487b7160e01b61010051526041600452602461010051fd5b01519050388062000219565b60019194505261010051906020822091935b601f198416851062000991576001945083601f1981161062000977575b505050811b016001556200022f565b015160001960f88460031b161c1916905538808062000968565b818101518355602094850194600190930192909101906200094b565b909150600161010051526101005160208120601f850160051c81016020861062000a01575b9085949392915b601f840160051c82018110620009f257505050620001f8565b828155869550600101620009d9565b5080620009d2565b91607f1691620001e0565b60405162461bcd60e51b815260206004820152600c60248201526b04c5020706374203e203130360a41b6044820152606490fd5b60405162461bcd60e51b815260206004820152601060248201526f50726573616c652070637420312d393960801b6044820152606490fd5b60639150111538620001a6565b60405162461bcd60e51b815260206004820152600b60248201526a57616c6c6574207a65726f60a81b6044820152606490fd5b60405162461bcd60e51b815260206004820152601060248201526f119a5b1b080f081b5a5b9d0818dbdcdd60821b6044820152606490fd5b60405162461bcd60e51b815260206004820152600d60248201526c04d696e7420636f7374203e203609c1b6044820152606490fd5b60405162461bcd60e51b815260206004820152600d60248201526c046696c6c206d757374203e203609c1b6044820152606490fd5b60405162461bcd60e51b815260206004820152601060248201526f54617820616c6c6f63203e203130302560801b6044820152606490fd5b60405162461bcd60e51b81526020600482015260116024820152700a6cad8d840e8c2f040e8dede40d0d2ced607b1b6044820152606490fd5b62461bcd60e51b815260206004820152601060248201526f084eaf240e8c2f040e8dede40d0d2ced60831b6044820152606490fd5b6001600160401b03811162000c1c57604052565b634e487b7160e01b600052604160045260246000fd5b601f909101601f19168101906001600160401b0382119082101762000c1c57604052565b919080601f8401121562000698578251906001600160401b03821162000c1c576040519160209162000c92601f8301601f191684018562000c32565b818452828287010111620006985760005b81811062000cb957508260009394955001015290565b858101830151848201840152820162000ca3565b51906001600160a01b03821682036200069857565b9190820180921162000cf057565b634e487b7160e01b600052601160045260246000fd5b8181029291811591840414171562000cf05756fe60406080815260049081361015610045575b5050361561001e57600080fd5b60ff601754168061003a575b61003057005b610038612650565b005b50601054341461002a565b600091823560e01c908162eeb44314611c8c5781630442bfa814611b9657816304b6d7ce146115b457816306fdde0314611ada5781630807b9e214611abb578163095ea7b314611a915781630f44f3a714611a475781631249c58b14611a33578163149555af146119655781631694505e1461193c57816318160ddd1461191d5781631d111d13146118cb578163232452161461185057816323b872dd146117a25781632c1f521614611779578163313ce5671461175d57816338e21cce14611723578163396d3d7c1461170457816349bd5a5e146116db5781634ada218b14610b2d5781634b4687b5146113f257816353135ca0146116b757816353deb3d614611698578382635999095e14611628575081635d098b38146115d857816366e3540a146115b95781636817c76c146115b457816370a082311461157e578163715018a6146115225781637515d1551461150357816375f0a874146114da57816385e34e9c146114bb5781638a8c523c146114195781638ab148fb146113f25781638cd09d50146113bb5781638da5cb5b146113935781639042ee96146113745783826391c04cfb146112f3575081639242338314610db357816395d89b41146111f057816398acb5d81461117f5781639b19251a146111415781639c8f9f2314610e5b57838263a04eab9714610dd257508163a2309ff814610db3578163a4c3b09114610d2e578163a5bb096d14610c9b578163a9059cbb14610c6a578163addc831e14610c24578163ae9bb3fa14610bda578163b4a735b214610bb157838263b5bc09d514610b5457508163bbc0c74214610b2d578163c2fe651e14610b0e578163c473413a14610aef578163c6a3064714610a96578163c9f62af214610a77578163cb4ca63114610a39578163cffd129c14610a1a578163d3fa94f8146109cb578163dc1052e214610994578163dd62ed3e14610946578163de11473e1461092b578163e4456ecb14610686578163e51fde321461066757838263e7ce0a41146105e957508163edac985b14610566578163efaa74421461050757838263f0fc6bca1461047d57508163f2fde38b146103c957508063fb86a404146103ab5763fbbf8cc30361001157346103a75760203660031901126103a75760209181906001600160a01b03610397611e7b565b1681526016845220549051908152f35b5080fd5b50346103a757816003193601126103a7576020906014549051908152f35b905034610479576020366003190112610479576103e4611e7b565b8354916001600160a01b03808416926103fe338514611f03565b1693841561043e57505082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08580a36001600160a01b03191617815580f35b906020606492519162461bcd60e51b835282015260156024820152744f776e61626c653a207a65726f206164647265737360581b6044820152fd5b8280fd5b92915034610503578260031936011261050357602090604460018060a01b03601a5416918451958693849263bc4c4b3760e01b845233908401528160248401525af19081156104fa57506104cf575080f35b6104ef9060203d81116104f3575b6104e78183611f79565b810190612af5565b5080f35b503d6104dd565b513d84823e3d90fd5b5050fd5b8390346103a75760203660031901126103a7573561052f60018060a01b038354163314611f03565b6105606127106105596105506105476009548661255b565b600b549061255b565b600a549061255b565b1115612a0c565b60085580f35b839150346103a75761057736611ea7565b83549194916001600160a01b0391906105939083163314611f03565b845b8181106105a0578580f35b826105b46105af83858b612616565b61263c565b1686526018602052838620600160ff19825416179055600181018091111561059557634e487b7160e01b865260118552602486fd5b809184346105035760203660031901126105035782546001600160a01b03906106159082163314611f03565b601a541691823b156106625783926024849284519586938492635ebf4db960e01b84528035908401525af19081156104fa575061064f5750f35b61065890611f4f565b61065f5780f35b80fd5b505050fd5b5050346103a757816003193601126103a757602090600b549051908152f35b919050346104795760209081600319360112610927578354833591906001600160a01b039081166106b8338214611f03565b8391600e54818116156107ef575b50600e5416906106d7821515612a66565b83516370a0823160e01b815230888201529688908789602481875afa80156107e55788998399979899916107a8575b5061075b98156107a0575b61072790868015159182610795575b5050612aa9565b865163a9059cbb60e01b81526001600160a01b03909316908301908152602081019490945290958693849291839160400190565b03925af190811561078c575061076f578280f35b8161078592903d106104f3576104e78183611f79565b5038808280f35b513d85823e3d90fd5b101590508638610720565b945084610711565b925050969481813d83116107de575b6107c18183611f79565b810103126107d95761075b9688958a92519098610706565b600080fd5b503d6107b7565b86513d84823e3d90fd5b600d54855163c45a015560e01b815290831688828b81845afa9182156108fe578a92918a918d93610908575b5088516315ab88c960e31b815293849182905afa9182156108fe57918991610879938d926108df575b50885163e6a4390560e01b815230818e019081526001600160a01b039093166020840152938492839188918391604090910190565b0392165afa9081156108d5579083918b916108a8575b5016906001600160601b0360a01b1617600e55386106c6565b6108c89150893d8b116108ce575b6108c08183611f79565b810190612a47565b3861088f565b503d6108b6565b86513d8c823e3d90fd5b6108f7919250833d85116108ce576108c08183611f79565b9038610844565b87513d8d823e3d90fd5b610920919350823d84116108ce576108c08183611f79565b913861081b565b8380fd5b5050346103a757816003193601126103a75751908152602090f35b5050346103a757806003193601126103a757602091610963611e7b565b8261096c611e91565b6001600160a01b03928316845260058652922091166000908152908352819020549051908152f35b8390346103a75760203660031901126103a757356109bc60018060a01b038354163314611f03565b6109c481116103a75760065580f35b8390346103a75760203660031901126103a757356109f360018060a01b038354163314611f03565b610a1461271061055983610a0f6105476008546009549061255b565b61255b565b600a5580f35b5050346103a757816003193601126103a7576020906007549051908152f35b5050346103a75760203660031901126103a75760209160ff9082906001600160a01b03610a64611e7b565b168152600f855220541690519015158152f35b5050346103a757816003193601126103a757602090600a549051908152f35b5050346103a757806003193601126103a757610ab0611e7b565b90610ab9611ef4565b835490926001600160a01b0391610ad39083163314611f03565b168352600f60205282209060ff80198354169115151617905580f35b5050346103a757816003193601126103a7576020906006549051908152f35b5050346103a757816003193601126103a7576020906014549051908152f35b5050346103a757816003193601126103a75760209060ff600e5460a01c1690519015158152f35b8091843461050357826003193601126105035782546001600160a01b0390610b7f9082163314611f03565b601a541691823b1561066257815163f26b854f60e01b81529284918491829084905af19081156104fa575061064f5750f35b5050346103a757816003193601126103a757601b5490516001600160a01b039091168152602090f35b8390346103a75760203660031901126103a757358015158091036107d957610c0c60018060a01b038354163314611f03565b61ff006017549160081b169061ff0019161760175580f35b8390346103a75760203660031901126103a75735610c4c60018060a01b038354163314611f03565b610c646127106105596105506105478560085461255b565b60095580f35b5050346103a757806003193601126103a757602090610c94610c8a611e7b565b6024359033612068565b5160018152f35b5050346103a75760203660031901126103a757610cb6611e7b565b82546001600160a01b03918291610cd09083163314611f03565b168091610cde82151561200d565b81601b549182167fec41c84876bdf5a35542949bdece4d9ccaed0b6e056ceaedec4d36e81cc77b478780a36001600160a01b03191617601b558252600f6020528120805460ff1916600117905580f35b919050346104795780600319360112610479576020610d9e92610d4f611e7b565b85546001600160a01b03908116908790610d6a338414611f03565b865163a9059cbb60e01b81526001600160a01b03909316948301948552602435602086015291968794859391849160400190565b0393165af19081156104fa57506104cf575080f35b5050346103a757816003193601126103a7576020906015549051908152f35b9291503461050357602036600319011261050357606090602460018060a01b03610e00818754163314611f03565b601a5416918451958693849263ffb2c47960e01b84528035908401525af19081156104fa5750610e2e575080f35b610e4e9060603d8111610e54575b610e468183611f79565b81019061258b565b50505080f35b503d610e3c565b905034610479576020908160031936011261092757808391359260018060a01b0390610e8b828854163314611f03565b8490600e5483811615611027575b5082600e5416610eaa811515612a66565b85516370a0823160e01b815230868201528281602481855afa90811561101d578a91610fe8575b50610f299715610fe0575b8291610ef48592838015159182610fd5575050612aa9565b85600d54168b8951809b8195829463095ea7b360e01b84528c840160209093929193604081019460018060a01b031681520152565b03925af1958615610fcb57610f6796610fad575b50508682600d54169281541691855196879586948593629d473b60e21b85524292309086016129d8565b03925af18015610fa157610f79578280f35b813d8311610f9a575b610f8c8183611f79565b8101031261065f5738808280f35b503d610f82565b505051903d90823e3d90fd5b81610fc392903d106104f3576104e78183611f79565b503880610f3d565b85513d8a823e3d90fd5b101590508338610720565b925082610edc565b809750838092503d8311611016575b6110018183611f79565b810103126107d9579451879590610f29610ed1565b503d610ff7565b87513d8c823e3d90fd5b600d54865163c45a015560e01b81529085168a84838981855afa92831561111657889286918395611122575b508a516315ab88c960e31b815293849182905afa92831561111657879386936110af93916110f9575b508a5163e6a4390560e01b8152308b82019081526001600160a01b03909216602083015294859384928391604090910190565b0392165afa801561101d5785918b916110dc575b5016906001600160601b0360a01b1617600e5538610e99565b6110f39150843d86116108ce576108c08183611f79565b386110c3565b6111109150843d86116108ce576108c08183611f79565b3861107c565b508851903d90823e3d90fd5b61113a919550823d84116108ce576108c08183611f79565b9338611053565b5050346103a75760203660031901126103a75760209160ff9082906001600160a01b0361116c611e7b565b1681526018855220541690519015158152f35b8390346103a75760203660031901126103a757356001600160a01b0381811691829003610479576111b4818454163314611f03565b81601a549182167fdab7e227381106009c2eb953811a49c7e30de8e9eb12e2aedb79b25c22f474b98580a36001600160a01b03191617601a5580f35b91905034610479578260031936011261047957805191836002549060019082821c9282811680156112e9575b60209586861082146112d657508488529081156112b4575060011461125b575b611257868661124d828b0383611f79565b5191829182611e32565b0390f35b929550600283527f405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace5b8284106112a157505050826112579461124d92820101943861123c565b8054868501880152928601928101611284565b60ff191687860152505050151560051b830101925061124d826112573861123c565b634e487b7160e01b845260229052602483fd5b93607f169361121c565b8091843461050357806003193601126105035761130e611e7b565b611316611ef4565b845490916001600160a01b03916113309083163314611f03565b81601a541690813b15611370578660449281958751988996879562241fbd60e51b87521690850152151560248401525af19081156104fa575061064f5750f35b8680fd5b5050346103a757816003193601126103a7576020906019549051908152f35b5050346103a757816003193601126103a757905490516001600160a01b039091168152602090f35b8390346103a75760203660031901126103a757356113e360018060a01b038354163314611f03565b6109c481116103a75760075580f35b5050346103a757816003193601126103a75760209060ff60175460081c1690519015158152f35b90503461047957826003193601126104795761143f60018060a01b038454163314611f03565b600e549160ff8360a01c1661148757505060ff60a01b1916600160a01b17600e557f799663458a5ef2936f7fa0c99b3336c69c25890f82974f04e811e5bb359186c78180a180f35b906020606492519162461bcd60e51b8352820152600e60248201526d416c72656164792061637469766560901b6044820152fd5b5050346103a757816003193601126103a7576020906013549051908152f35b5050346103a757816003193601126103a757600c5490516001600160a01b039091168152602090f35b5050346103a757816003193601126103a7576020906010549051908152f35b833461065f578060031936011261065f578054816001600160a01b03821661154b338214611f03565b7f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a36001600160a01b031916815580f35b9050346104795760203660031901126104795760209282916001600160a01b036115a6611e7b565b168252845220549051908152f35b611e14565b5050346103a757816003193601126103a7576020906008549051908152f35b833461065f57602036600319011261065f576115f2611e7b565b81546001600160a01b03919061160b9083163314611f03565b1680156103a7576001600160601b0360a01b600c541617600c5580f35b929150346105035760203660031901126105035782546001600160a01b03906116549082163314611f03565b601a5416803b156106625760248492845195869384926302f08a5160e21b84528035908401525af19081156104fa575061168c575080f35b61169590611f4f565b80f35b5050346103a757816003193601126103a7576020906009549051908152f35b5050346103a757816003193601126103a75760209060ff6017541690519015158152f35b5050346103a757816003193601126103a757600e5490516001600160a01b039091168152602090f35b5050346103a757816003193601126103a7576020906012549051908152f35b5050346103a75760203660031901126103a75760209181906001600160a01b0361174b611e7b565b16815260168452205415159051908152f35b5050346103a757816003193601126103a7576020905160128152f35b5050346103a757816003193601126103a757601a5490516001600160a01b039091168152602090f35b839150346103a75760603660031901126103a7576117be611e7b565b6117c6611e91565b6001600160a01b03821684526005602090815285852033865290529284902054604435939284821061180d57602086610c948787876118088389033383611f9b565b612068565b606490602087519162461bcd60e51b8352820152601760248201527f45524332303a2065786365656420616c6c6f77616e63650000000000000000006044820152fd5b839150346103a75761186136611ea7565b83549194916001600160a01b03919061187d9083163314611f03565b845b81811061188a578580f35b826118996105af83858b612616565b168652601860205283862060ff198154169055600181018091111561187f57634e487b7160e01b865260118552602486fd5b5050346103a757816003193601126103a7578180808060018060a01b038154166118f6338214611f03565b4790828215611914575bf11561190a575080f35b51903d90823e3d90fd5b506108fc611900565b5050346103a757816003193601126103a7576020906003549051908152f35b5050346103a757816003193601126103a757600d5490516001600160a01b039091168152602090f35b90503461047957826003193601126104795782546001600160a01b039061198f9082163314611f03565b80601b5416156119f757308452816020528284209184835493846119b1575080f35b5581601b5416908186526119c8848688205461255b565b91865260205283852055601b54169151908152600080516020612b0e83398151915260203092a3388080808480f35b506020606492519162461bcd60e51b8352820152601660248201527515185e111a5cdd1c9a589d5d1bdc881b9bdd081cd95d60521b6044820152fd5b838060031936011261065f57611695612650565b8390346103a75760203660031901126103a75735611a6f60018060a01b038354163314611f03565b611a8b61271061055961055084610a0f6008546009549061255b565b600b5580f35b5050346103a757806003193601126103a757602090610c94611ab1611e7b565b6024359033611f9b565b5050346103a757816003193601126103a7576020906011549051908152f35b9190503461047957826003193601126104795780519183600180549182821c928281168015611b8c575b60209586861082146112d657508488529081156112b45750600114611b3457611257868661124d828b0383611f79565b9295508083527fb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf65b828410611b7957505050826112579461124d92820101943861123c565b8054868501880152928601928101611b5c565b93607f1693611b04565b905034610479578160031936011261047957803560243590611bc260018060a01b038654163314611f03565b801593841580611c82575b15611c4f575080601055816014556003549360195494858102958187041490151715611c3c57611c3857611c0091612048565b9081606402916064830403611c255750801561047957611c1f91612048565b60115580f35b634e487b7160e01b845260119052602483fd5b8480fd5b634e487b7160e01b865260118452602486fd5b5162461bcd60e51b8152602081850152600e60248201526d496e76616c696420706172616d7360901b6044820152606490fd5b5081831015611bcd565b91602091503660031901821361092757823560018060a01b03611cb3818754163314611f03565b3415611de6578115611db057308652848452818387205410611d77578181611ce5611d0b94606094600d541630611f9b565b80600d541690885416855180958194829363f305d71960e01b84524291308d86016129d8565b039134905af19081611d59575b50611d55575162461bcd60e51b8152918201526014602482015273105919081b1a5c5d5a591a5d1e4819985a5b195960621b604482015260649150fd5b8380f35b611d709060603d8111610e5457610e468183611f79565b5050611d18565b50505162461bcd60e51b8152918201526013602482015272496e73756666696369656e7420746f6b656e7360681b604482015260649150fd5b50505162461bcd60e51b815291820152601060248201526f0546f6b656e20616d6f756e74203e20360841b604482015260649150fd5b50505162461bcd60e51b815291820152600860248201526729b2b7321021272160c11b604482015260649150fd5b346107d95760003660031901126107d9576020601054604051908152f35b6020808252825181830181905290939260005b828110611e6757505060409293506000838284010152601f8019910116010190565b818101860151848201604001528501611e45565b600435906001600160a01b03821682036107d957565b602435906001600160a01b03821682036107d957565b9060206003198301126107d95760043567ffffffffffffffff928382116107d957806023830112156107d95781600401359384116107d95760248460051b830101116107d9576024019190565b6024359081151582036107d957565b15611f0a57565b60405162461bcd60e51b815260206004820152601c60248201527f4f776e61626c653a2063616c6c6572206973206e6f74206f776e6572000000006044820152606490fd5b67ffffffffffffffff8111611f6357604052565b634e487b7160e01b600052604160045260246000fd5b90601f8019910116810190811067ffffffffffffffff821117611f6357604052565b90916001600160a01b039182169182151580612002575b156107d9577f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925916020918460005260058352604060002095169485600052825280604060002055604051908152a3565b508084161515611fb2565b1561201457565b60405162461bcd60e51b815260206004820152600c60248201526b5a65726f206164647265737360a01b6044820152606490fd5b8115612052570490565b634e487b7160e01b600052601260045260246000fd5b9092916001600160a01b038083169182151580612550575b6120899061200d565b801561251d576000958387526004966020938885526040928484842054106124e357600e549782891698898914809181156124d7575b816124c8575b50612465575b80612455575b838316998a1480612447575b85918a8752600f8a5260ff88882054161580612436575b6123dc575b5050612118612108828961257e565b978a87528d8a528787205461257e565b8986528c895286862055898552612132878787205461255b565b8a86528c895286862055801580156121d4575b5050600080516020612b0e8339815191529798999a9161216761216c926125a6565b6125a6565b60ff601b5460a01c1615612185575b50505051908152a3565b6024620186a091606093601a5416948651958694859363ffb2c47960e01b85528401525af16121b6575b808061217b565b6121cd9060603d8111610e5457610e468183611f79565b50506121af565b60095490818302918383041417156123c957896121f76127108b9304809461257e565b92806123a7575b505050801515808061239a575b1561234457503085528b8852612224818787205461255b565b3086528c89528686205583601b5416808652612243828888205461255b565b9086528c89528686205583601b541680918751908152600080516020612b0e8339815191528a3092a38551636fdaa73d60e11b8982019081528d825267ffffffffffffffff92918089018481118282101761233057895251879283929083905af1503d1561230f573d9081116122fc579161216761216c92600080516020612b0e8339815191529a9b9c9d948851906122e58c601f19601f8401160183611f79565b8152878b3d92013e5b925081939c9b9a9950612145565b634e487b7160e01b855260418c52602485fd5b50600080516020612b0e8339815191529798999a9161216761216c926122ee565b8f896041602492634e487b7160e01b835252fd5b61216c92600080516020612b0e8339815191529a9b9c9d94926121679261236c575b506122ee565b308852858b5261237f818a8a205461255b565b308952868c528989205588519081528c8c8c3093a338612366565b5084601b5416151561220b565b61dead92600080516020612b0e833981519152918a51908152a38789386121fe565b634e487b7160e01b865260118d52602486fd5b61241a575b6123ed575b38806120f9565b5060075480870290878204036124075761271090046123e6565b634e487b7160e01b855260118c52602485fd5b905060065480880290888204036123c9576127109004906123e1565b508b875260ff8888205416156120f4565b5083600d54168914156120dd565b5082600d541683831614156120d1565b888552600f885260ff868620541680156124b6575b6120cb57855162461bcd60e51b8152808d01899052601260248201527154726164696e67206e6f742061637469766560701b6044820152606490fd5b50838316855260ff868620541661247a565b60ff915060a01c1615386120c5565b8486168c1491506120bf565b835162461bcd60e51b8152808b018790526014602482015273496e73756666696369656e742062616c616e636560601b6044820152606490fd5b60405162461bcd60e51b815260206004820152600b60248201526a416d6f756e74207a65726f60a81b6044820152606490fd5b508582161515612080565b9190820180921161256857565b634e487b7160e01b600052601160045260246000fd5b9190820391821161256857565b908160609103126107d9578051916040602083015192015190565b60018060a01b0380601a541691166000908082526004602052604082205490833b156104795790604483928360405196879485936338c110ef60e21b8552600485015260248401525af190811561260a57506125ff5750565b61260890611f4f565b565b604051903d90823e3d90fd5b91908110156126265760051b0190565b634e487b7160e01b600052603260045260246000fd5b356001600160a01b03811681036107d95790565b60175460ff81161561299e5760105434036129645760081c60ff16612917575b60155461267d348261255b565b601454106128e35761269090349061255b565b601555601154906000308152600492602093808552604091828420546126b86012548361255b565b116128a1573384528186526126d0818486205461255b565b338552828752838520553084526126ea818486205461257e565b3085528287528385205533845260168652612708818486205461255b565b3385526016875283852055825134815281878201527f4c209b5fc8ad50758f13e2e1088ba56a560dff690a1c6fef26394f4c03821c4f843392a282519081523390600080516020612b0e833981519152873092a3612765336125a6565b601254806127ea575b50505090915060155460145411156127835750565b7f799663458a5ef2936f7fa0c99b3336c69c25890f82974f04e811e5bb359186c79060ff19601754166017557f1eb1561f8507eb9bc6988331f66f369e75710f2b4b678ad5b4a52454b6636f5f8180a1600e805460ff60a01b1916600160a01b17905580a1565b6128309160609160018060a01b03906128088183600d541630611f9b565b81600d5416918754169086519586948593849363f305d71960e01b85524292309086016129d8565b039134905af18015610fa1578394957f03f82d6e9655f3dcff58c68e61adfad355b92c77a8fde4d53a423a6c58e293479492869261287d575b508351928352820152a1819038808061276e565b909250612898915060603d8111610e5457610e468183611f79565b50909138612869565b5084606492519162461bcd60e51b8352820152601d60248201527f496e73756666696369656e7420636f6e74726163742062616c616e63650000006044820152fd5b60405162461bcd60e51b815260206004820152600c60248201526b141c995cd85b1948199d5b1b60a21b6044820152606490fd5b33600052601860205260ff604060002054166126705760405162461bcd60e51b815260206004820152600f60248201526e139bdd081dda1a5d195b1a5cdd1959608a1b6044820152606490fd5b60405162461bcd60e51b8152602060048201526012602482015271125b9d985b1a590810939088185b5bdd5b9d60721b6044820152606490fd5b60405162461bcd60e51b815260206004820152601260248201527150726573616c65206e6f742061637469766560701b6044820152606490fd5b9060a09295949360c0830196600180861b038093168452602084015260006040840152600060608401521660808201520152565b15612a1357565b60405162461bcd60e51b815260206004820152600c60248201526b546f74616c203e203130302560a01b6044820152606490fd5b908160209103126107d957516001600160a01b03811681036107d95790565b15612a6d57565b60405162461bcd60e51b815260206004820152601460248201527314185a5c881b9bdd0818dc99585d1959081e595d60621b6044820152606490fd5b15612ab057565b60405162461bcd60e51b815260206004820152601760248201527f496e73756666696369656e74204c502062616c616e63650000000000000000006044820152606490fd5b908160209103126107d9575180151581036107d9579056feddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3efa264697066735822122007fcb2366a395cdf4b5e87084b265ab289b88fa8c9651891db0fe8640e8b200764736f6c634300081400336080346100b657601f61155038819003918201601f19168301916001600160401b038311848410176100bb5780849260409485528339810103126100b65780516020909101516001600160a01b03908181168082036100b6576100b15750335b16908160018060a01b031960005416176000556040519160007f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08180a361012c600c55600d5561147e90816100d28239f35b61005f565b600080fd5b634e487b7160e01b600052604160045260246000fdfe60406080815260049081361015610105575b361561001c57600080fd5b61003160018060a01b03600054163314610ac3565b600e5480156100c257341590811561004557005b600154913460801b90348204600160801b1417156100ad57610071929161006b91610b0f565b90610b2f565b600155513481527fa493a9229478c3fcd73f66d2cdeb7f94fd0f341da924d1054236d7845411651160203392a26100a9348254610b2f565b9055005b601185634e487b7160e01b6000525260246000fd5b815162461bcd60e51b8152602081850152601d60248201527f4469766964656e64506179696e67546f6b656e3a20737570706c793d300000006044820152606490fd5b6000803560e01c80630342a978146109f55780630483f7a01461095d57806309bbedde1461093e5780630bc22944146108e457806318160ddd146108c5578063226cfa3d1461088d57806327ce0147146108675780633009a609146108485780634e71d92d146107c85780634e7b827f1461078a5780635ebf4db91461075c5780636843cd84146107365780636a474002146107225780636f2789ec1461070357806370a08231146106cb578063715018a61461066f57806385a6b3ae146106515780638da5cb5b14610629578063a30dee3014610527578063a8b9d240146104fa578063aafd847a146104c2578063bc4c4b37146103e6578063be10b614146103c7578063e30443bc1461038b578063f26b854f14610321578063f2fde38b1461026d5763ffb2c4791461023a5750610011565b3461026a57602036600319011261026a57506102586060923561131b565b91929081519384526020840152820152f35b80fd5b50913461031d57602036600319011261031d57610288610a99565b8354916001600160a01b03808416926102a2338514610ac3565b169384156102e257505082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08580a36001600160a01b03191617815580f35b906020606492519162461bcd60e51b835282015260156024820152744f776e61626c653a207a65726f206164647265737360581b6044820152fd5b8280fd5b509034610387578160031936011261038757815482906001600160a01b031661034b338214610ac3565b479081158015610359578380f35b839283928392839061037e575bf11561037457818180808380f35b51903d90823e3d90fd5b506108fc610366565b5080fd5b5090346103875736600319011261026a576103c46103a7610a99565b6103bb60018060a01b038454163314610ac3565b60243590610c07565b80f35b509034610387578160031936011261038757602090600d549051908152f35b50903461038757806003193601126103875790602091610404610a99565b61040c610ab4565b83546001600160a01b03949184916104279087163314610ac3565b159485610499575b83169261044461043e85610b65565b91611022565b9586610456575b878784519015158152f35b83857fa2c38e2d2fb7e3e1912d937fd1ca11ed6d51864dee4cfa7a7bf02becd7acf0929552600b8952834291205582519182521587820152a2838082818061044b565b8084168352600b87526104bd6104b583852054600c5490610b2f565b421015611407565b61042f565b5090346103875760203660031901126103875760209181906001600160a01b036104ea610a99565b1681526003845220549051908152f35b5090346103875760203660031901126103875760209061052061051b610a99565b610b65565b9051908152f35b5091903461031d57602036600319011261031d5781359061055260018060a01b038554163314610ac3565b600e5480156105e6578215908115610568578580f35b60015491608085901b90600160801b8683041417156105d3579161006b610594926105c8969594610b0f565b600155518181527fa493a9229478c3fcd73f66d2cdeb7f94fd0f341da924d1054236d7845411651160203392a28254610b2f565b905538808080808580f35b634e487b7160e01b875260118652602487fd5b815162461bcd60e51b8152602081860152601d60248201527f4469766964656e64506179696e67546f6b656e3a20737570706c793d300000006044820152606490fd5b509034610387578160031936011261038757905490516001600160a01b039091168152602090f35b50913461031d578260031936011261031d5760209250549051908152f35b503461026a578060031936011261026a578054816001600160a01b038216610698338214610ac3565b7f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e08280a36001600160a01b031916815580f35b5090346103875760203660031901126103875760209181906001600160a01b036106f3610a99565b1681526006845220549051908152f35b509034610387578160031936011261038757602090600c549051908152f35b503461026a578060031936011261026a5780f35b5090346103875760203660031901126103875790602091610755610a99565b5051908152f35b5082346103875760203660031901126103875761078360018060a01b038354163314610ac3565b35600d5580f35b5090346103875760203660031901126103875760209160ff9082906001600160a01b036107b5610a99565b168152600a855220541690519015158152f35b509034610387578160031936011261038757338252600b6020526107f56104b582842054600c5490610b2f565b7fa2c38e2d2fb7e3e1912d937fd1ca11ed6d51864dee4cfa7a7bf02becd7acf09261081f33610b65565b9161082933611022565b50338452600b602052428185205580519283528360208401523392a280f35b5090346103875781600319360112610387576020906009549051908152f35b50903461038757602036600319011261038757602090610520610888610a99565b610bbe565b5090346103875760203660031901126103875760209181906001600160a01b036108b5610a99565b168152600b845220549051908152f35b509034610387578160031936011261038757602090600e549051908152f35b50913461031d57602036600319011261031d577f4b0a6b82d0dc4407b3359033a4f27efd1e2105e4571b72d6a3b8f1da3e6079dd91602091359061093260018060a01b038654163314610ac3565b81600c5551908152a180f35b5090346103875781600319360112610387576020906005549051908152f35b5090346103875780600319360112610387577f50b9be6d475eaa75d2387ce1985972767cbe50d0b6e16cffd31a82062cbfbc75602061099a610a99565b926109a3610ab4565b9060018060a01b036109b9818854163314610ac3565b851694858752600a8452818720928015159360ff1981541660ff86161790556109e6575b5051908152a280f35b6109ef90610f55565b866109dd565b50913461031d578160031936011261031d57610a1683916024359035611219565b9091835193849381850191855280518092526060850191602080920190845b818110610a7957505050848203818601528080855193848152019401925b828110610a6257505050500390f35b835185528695509381019392810192600101610a53565b82516001600160a01b031685528897509383019391830191600101610a35565b600435906001600160a01b0382168203610aaf57565b600080fd5b602435908115158203610aaf57565b15610aca57565b60405162461bcd60e51b815260206004820152601c60248201527f4f776e61626c653a2063616c6c6572206973206e6f74206f776e6572000000006044820152606490fd5b8115610b19570490565b634e487b7160e01b600052601260045260246000fd5b91908201809211610b3c57565b634e487b7160e01b600052601160045260246000fd5b81810292918115918404141715610b3c57565b610b9290610b7281610bbe565b6001600160a01b0390911660009081526003602052604090205490610b95565b90565b91908203918211610b3c57565b91909160008382019384129112908015821691151617610b3c57565b60018060a01b03166000526006602052610bf66040600020546002602052610bee60406000205491600154610b52565b60801c610ba2565b60008112610c015790565b50600090565b6001600160a01b03166000818152600a602090815260408083205490939060ff16610d3857600d548510610d285780835260028252610cc884842054956008845260ff8686205416600014610d1e5760068452610cc286862054975b848752600886528787205460ff1615610d0057610c8d600e54868952600688528989205490610b95565b600e55848752600686528288882055610ca883600e54610b2f565b600e555b610cb9600154998a610b52565b60801c90610ba2565b96610b52565b60801c94838682039612818712811691871390151617610cec578252600290522055565b634e487b7160e01b83526011600452602483fd5b610d0a8386610ebc565b610d1683600e54610b2f565b600e55610cac565b610cc28597610c63565b92505050610d369150610f55565b565b935090600860ff939252205416610d4c5750565b610d3690610da2565b600554811015610d8c5760056000527f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db00190600090565b634e487b7160e01b600052603260045260246000fd5b6001600160a01b0390811660008181526008602090815260408083205492949093919260ff1615610eb55760078352838520546005546000199190828101908111610ea1578084918303610e52575b5050506005548015610e3e576007949392910190610e0e82610d55565b909182549160031b1b1916905560055584526008815282842060ff19815416905560068152838381205552812055565b634e487b7160e01b87526031600452602487fd5b610e5b90610d55565b90549060031b1c16610e8f81610e7084610d55565b90919082549060031b9160018060a01b03809116831b921b1916179055565b87526007855285872055388281610df1565b634e487b7160e01b88526011600452602488fd5b5050505050565b6001600160a01b0381166000908152600860205260408120549192909160ff16610f4757600860205260408220600160ff198254161790556006602052604082205560055490600760205281604082205568010000000000000000821015610f33575090610e70826001610d369401600555610d55565b634e487b7160e01b81526041600452602490fd5b915060409060066020522055565b6001600160a01b03811660008181526008602052604081205490929060ff1615610fc157610fa890610f8683611022565b50610fa0600e548486526006602052604086205490610b95565b600e55610da2565b8152600260205280604081205560036020526040812055565b505050565b604051906020820182811067ffffffffffffffff821117610fe657604052565b634e487b7160e01b600052604160045260246000fd5b6040519190601f01601f1916820167ffffffffffffffff811183821017610fe657604052565b6001600160a01b031661103481610b65565b9081611041575050600090565b60009181835260206003815260409161105d8184872054610b2f565b8486526003835283862055837fee503bee2bb6a87e57bc57db795f98137327401a0e7b7ce42e37926cc1a9ca4d838551848152a28480808084885af13d156111bb573d67ffffffffffffffff81116111a7576110c1601f8201601f19168501610ffc565b90815286843d92013e5b156110da575050505050600190565b8385526003825282852054835184810181811067ffffffffffffffff821117611193578552600f81526e15da5d1a191c985dc819985a5b1959608a1b8482015281831161113957506003929161112f91610b95565b9385525282205590565b839087865192839162461bcd60e51b8352816004840152835191826024850152815b83811061117c57505060448094508284010152601f80199101168101030190fd5b80860182015187820160440152869450810161115b565b634e487b7160e01b88526041600452602488fd5b634e487b7160e01b87526041600452602487fd5b6110cb565b67ffffffffffffffff8111610fe65760051b60200190565b906111ea6111e5836111c0565b610ffc565b82815280926111fb601f19916111c0565b0190602036910137565b8051821015610d8c5760209160051b010190565b91906112259083610b2f565b600554808211611313575b50808310156112ed5761124b6112468483610b95565b6111d8565b906112596112468583610b95565b93805b82811061126a575050509190565b604061127582610d55565b90546001600160a01b039160039190821b1c821661129c6112968787610b95565b89611205565b526112a684610d55565b9054911b1c166000908152600660205220546112cb6112c58484610b95565b88611205565b52600181018091111561125c5760246000634e487b7160e01b81526011600452fd5b5090506112f8610fc6565b9060008252611305610fc6565b916000835260003681379190565b905038611230565b9060059182549081156113fa579190600954906000945a938692835b878910806113f1575b156113e0576001808701809711610b3c5786855411156113d7575b61136487610d55565b905460039190911b1c6001600160a01b031661137f81611022565b6113b6575b508101809111610b3c57955a908181116113a0575b5095611337565b9861006b826113af939b610b95565b9738611399565b95818101809111610b3c5795600052600b6020524260406000205538611384565b6000965061135b565b600986905597509295509293505050565b50818110611340565b5050600954600092508291565b1561140e57565b60405162461bcd60e51b815260206004820152601260248201527110db185a5b481dd85a5d081b9bdd081b595d60721b6044820152606490fdfea2646970667358221220986140c58a272360cdb95c2863dc6e5cd6ec7ac49ca32ab8e36ced0d2d96465264736f6c63430008140033"
};
