#!/bin/bash

echo -e "\e[1;32m How many subgraphs do you want to offchain sync? \e[0m"

read subsnumber

http  -b post https://api.thegraph.com/subgraphs/name/graphprotocol/graph-network-mainnet query="{subgraphDeployments(first:$subsnumber, orderBy:signalledTokens, orderDirection:desc, where:{signalledTokens_gt:0, deniedAt:0}) {ipfsHash}}" | jq -r .data.subgraphDeployments[].ipfsHash | sed -z 's/\n/,/g;s/,$/\n/' | tee offchain-subgraphs &> /dev/null &

echo -e "\e[1;32m Done 👏 \e[0m"
echo
echo -e "\e[1;32m Do you wish to add more subgraphs to the list? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo -e "\e[1;32m Enter your Subgraph ID or an array of Subgraph IDs (comma separated) \e[0m"
              read list
              sed -i "s/$/,$list/" offchain-subgraphs;break;;
        No ) break;;
    esac
done
echo -e "\e[1;32m Done 👏 \e[0m"

echo
echo -e "\e[1;32m Should I edit the start file with the changes for you? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
         Yes ) sed -i.bak "s/\(^INDEXER_AGENT_OFFCHAIN_SUBGRAPHS=.*\)/INDEXER_AGENT_OFFCHAIN_SUBGRAPHS=$(cat offchain-subgraphs) \\\/" start;break;;
         No ) exit;;
     esac
 done
 echo -e "\e[1;32m Done 👏 \e[0m"

echo
echo -e "\e[1;32m Should I restart the indexer-agent container for you so that the changes apply? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
         Yes ) bash start --force-recreate indexer-agent;break;;
         No ) exit;;
     esac
 done
 echo -e "\e[1;32m Done 👏 \e[0m"
