#!/bin/bash



ENV=./env




 ##############ICON
 ICON_ENV=$ENV/icon

 BRIDGE_CONTRACT_ADDRESS_FILE=$ICON_ENV/.bridgeContract


 ICON_BRIDGE_CONTRACT="./centralized-connection-0.1.0-optimized.jar"
 ICON_NODE="http://localhost:9082/api/v3"
 ICON_NETWORK_ID=3
 ICON_WALLET=/Users/viveksharmapoudel/keystore/ibc-icon/godWallet.json
 ICON_WALLET_PASSWORD=gochain
 STEP_LIMIT=10000000
 


 ####################EVM
 
 EVM_BLOCK_TIME=4
 EVM_CHAIN_ID=5

 EVM_NODE="http://localhost:8545"


 EVM_CONTRACT_DIRECTORY="/Users/viveksharmapoudel/my_work_bench/ibriz/ibc-related/xcall-multi/contracts/evm"
 EVM_CONTRACT_FILE=$EVM_CONTRACT_DIRECTORY"/contracts/adapters/CentralizedAdapter.sol"
#  private key which has balance
 EVM_PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
 EVM_CONTRACT_NAME="XCallCentralizeConnection"
 EVM_ENV=$ENV/evm
 EVM_BRIDGE_CONTRACT=$EVM_ENV/.bridgeContract
