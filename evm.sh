#!/bin/bash

source consts.sh



function runNode(){

    local action="anvil --block-time $EVM_BLOCK_TIME --chain-id $EVM_CHAIN_ID"
    ($action)

}

function deployContract(){

    cd $EVM_CONTRACT_DIRECTORY
    local action="forge create $EVM_CONTRACT_FILE:$EVM_CONTRACT_NAME --rpc-url $EVM_NODE --private-key=$EVM_PRIVATE_KEY"
    ($action)
    cd -
}


function sendMessage(){

    contract_address=$(cat $EVM_BRIDGE_CONTRACT)
    cd $EVM_CONTRACT_DIRECTORY
    local action="cast send $contract_address \"sendMessage(string,string,int256,bytes)\" \"hi\" \"hello\" 123 0x7b7d --private-key $EVM_PRIVATE_KEY"
    cd -
}




########## ENTRYPOINTS ###############

usage() {
    echo "Usage: $0 []"
    exit 1
}

if [ $# -ge 1 ]; then
	# create folder if not exists
	# if [ ! -d $WASM_CONTRACT_FOLDER ]; then
	# 	mkdir -p $WASM_CONTRACT_FOLDER
	# fi

    CMD=$1
	shift
else
    usage
fi


case "$CMD" in
    deploy-contract )
        deployContract
    ;;
    run-node )
        runNode
    ;;
    send-message )
        sendMessage
    ;;
    *)
        echo "Error: unknown command: $CMD"
        usage
    ;;
esac