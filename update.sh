#!/bin/bash

systemctl stop ag-chain-cosmos.service \
&& cd ~/agoric \
&& rm -rf agoric-sdk; \
git clone https://github.com/Agoric/agoric-sdk -b agorictest-9 \
&& cd agoric-sdk \
&& yarn install \
&& yarn build \
&& cd packages/cosmic-swingset \
&& make \
&& ag-chain-cosmos version \
&& cd ~/agoric \
&& curl https://testnet.agoric.net/network-config > chain.json \
&& chainName=`jq -r .chainName < chain` \
&& ag-chain-cosmos unsafe-reset-all \
&& curl https://testnet.agoric.net/genesis.json > $HOME/.ag-chain-cosmos/config/genesis.json \
&& peers=$(jq '.peers | join(",")' < chain.json) \
&& seeds=$(jq '.seeds | join(",")' < chain.json) \
&& sed -i.bak -e "s/^seeds *=.*/seeds = $seeds/; s/^persistent_peers *=.*/persistent_peers = $peers/" $HOME/.ag-chain-cosmos/config/config.toml \
&& systemctl start ag-chain-cosmos.service \
&& journalctl -u ag-chain-cosmos.service -f --no-hostname
