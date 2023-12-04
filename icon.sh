#!/bin/bash

source consts.sh


tx_call_args_icon_common=" --uri $ICON_NODE  --nid $ICON_NETWORK_ID  --step_limit $STEP_LIMIT --key_store $ICON_WALLET --key_password $ICON_WALLET_PASSWORD "

function printDebugTrace() {
	local txHash=$1
	goloop debug trace --uri $ICON_NODE_DEBUG $txHash | jq -r .
}


function wait_for_it() {
	local txHash=$1
	echo "Txn Hash: "$1
	
	status=$(goloop rpc txresult --uri $ICON_NODE $txHash | jq -r .status)
	if [ $status == "0x1" ]; then
    	echo "Successful"
    else
    	echo $status
    	read -p "Print debug trace? [y/N]: " proceed
    	if [[ $proceed == "y" ]]; then
    		printDebugTrace $txHash
    	fi
    	exit 0
    fi
}


function deployContract(){

 filename=$BRIDGE_CONTRACT_ADDRESS_FILE

 local txHash=$(goloop rpc sendtx deploy $ICON_BRIDGE_CONTRACT \
 --content_type application/java \
 --to cx0000000000000000000000000000000000000000 \
 --uri $ICON_NODE \
 --param _xCall="cx2e3c28fab67604ed977c3b59d6dc69c77a4e0522" \
 --nid $ICON_NETWORK_ID \
 --step_limit $STEP_LIMIT \
 --key_store $ICON_WALLET \
 --key_password $ICON_WALLET_PASSWORD | jq -r .)

 sleep 4
 wait_for_it $txHash
 scoreAddr=$(goloop rpc txresult --uri $ICON_NODE $txHash | jq -r .scoreAddress)
 echo "contract address is " $scoreAddr
 echo $scoreAddr > $filename

}

function sendMessage(){

    local addr=$(cat $BRIDGE_CONTRACT_ADDRESS_FILE)

	local txHash=$(goloop rpc sendtx call \
			--to $addr \
			--method sendMessage \
			--param to=avalanche \
			--param svc=svc \
            --param sn=0x11 \
            --param msg=0x6e696c696e \
			$tx_call_args_icon_common | jq -r .)

    echo $txHash
    sleep 4
    wait_for_it $txHash

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

	send-message )
	    sendMessage
	;;
	
	*)
    	echo "Error: unknown command: $CMD"
    	usage
    ;;
esac