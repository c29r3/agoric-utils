#!/bin/bash

SELF_ADDR="agoric1h3y305zhn2gtfg76qaz5ya0at52tvqw3a8rlcc"
OPERATOR="agoricvaloper1h3y305zhn2gtfg76qaz5ya0at52tvqw3dlskye"
WALLET_NAME="agoric"
CHAIN_ID="agorictest-16"
WALLET_PWD=""
RPC="http://localhost:29657"
BIN_FILE="/root/go/bin/ag-chain-cosmos"
TOKEN="ubld"


while true; do
    # withdraw reward
    echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx distribution withdraw-rewards $OPERATOR --commission --fees 110000$TOKEN --chain-id $CHAIN_ID --from $WALLET_NAME --node $RPC -y

    sleep 10

    # check current balance
    BALANCE=$($BIN_FILE q bank balances $SELF_ADDR --node $RPC  -o json | jq -r .balances[0].amount)
    echo CURRENT BALANCE IS: $BALANCE

    RESTAKE_AMOUNT=$(( $BALANCE - 10000000 ))

    if (( $RESTAKE_AMOUNT >=  10000000 ));then
        echo "Let's delegate $RESTAKE_AMOUNT of REWARD tokens to $SELF_ADDR"
        # delegate balance
        echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx staking delegate $OPERATOR "$RESTAKE_AMOUNT"$TOKEN --fees 110000$TOKEN --chain-id $CHAIN_ID --from $WALLET_NAME --node $RPC -y

    else
        echo "Reward is $RESTAKE_AMOUNT"
    fi
    echo "DONE"
    sleep 3600
done
