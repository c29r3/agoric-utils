#!/bin/bash

RPC=http://localhost:26657
UPDATE_URL="https://github.com/Agoric/ag0/releases/download/agoric-upgrade-6/ag0-agoric-upgrade-6-linux-amd64"
UNIT_NAME="agoric"
TARGET_BLOCK=5901622

#curl -s localhost:26657/status | jq -r .result.sync_info.latest_block_height

LAST_BLOCK=$(curl -s ${RPC}/status | jq -r .result.sync_info.latest_block_height)

while (( ${LAST_BLOCK} < ${TARGET_BLOCK} )); do
	LAST_BLOCK=$(curl -s ${RPC}/status | jq -r .result.sync_info.latest_block_height)
	blocks_before_update=$(echo "${TARGET_BLOCK} - ${LAST_BLOCK}" | bc -l)
	echo -e "Blocks before restart(update): ${blocks_before_update}"
	sleep 3
done

cd $HOME/go/bin
rm ag0
wget -O ag0 ${UPDATE_URL}
chmod u+x ag0

echo "restart system unit"
sudo systemctl restart ${UNIT_NAME}
exit 0
