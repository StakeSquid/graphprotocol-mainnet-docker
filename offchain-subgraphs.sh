#!/bin/bash

rm offchain-subgraphs

mainnet_networks=$(http -b post "https://api.thegraph.com/subgraphs/name/graphprotocol/graph-network-mainnet" query="{networks {id}}" | jq -r .data.networks[].id)# > mainnet_networks
testnet_networks=$(http -b post "https://api.thegraph.com/subgraphs/name/graphprotocol/graph-network-goerli" query="{networks {id}}" | jq -r .data.networks[].id)# > testnet_networks

repeat=1


while [ $repeat -gt 0 ]; do
echo -e "\e[1;32m Which graph indexer environment do you want to query? \e[0m"

select environment in "mainnet" "goerli"; do
    echo
    echo -e "\e[1;32m Which network do you want to sync subgraphs from? \e[0m"
    case $environment in
        mainnet ) select network in ${mainnet_networks}; do break;done;break;;
        goerli ) select network in ${testnet_networks}; do break;done;break;;
    esac
done
echo
echo -e "\e[1;32m How many subgraphs do you want to offchain sync from the available ${network} subgraphs on the ${environment} environment? \e[0m"

read subsnumber

http  -b post https://api.thegraph.com/subgraphs/name/graphprotocol/graph-network-${environment} query="{subgraphDeployments(first:$subsnumber, orderBy:signalledTokens, orderDirection:desc, where:{signalledTokens_gt:0, deniedAt:0, network:\"$network\"}) {ipfsHash}}" | jq -r .data.subgraphDeployments[].ipfsHash >> offchain-subgraphs

echo -e "\e[1;32m Done 👏 \e[0m"
echo

echo -e "\e[1;32m Do you wish to add more networks to the list? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) repeat=0;break;;
    esac
done
done

echo -e "\e[1;32m Done 👏 \e[0m"
echo
echo -e "\e[1;32m Do you wish to add more subgraphs to the list? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo -e "\e[1;32m Enter your Subgraph ID or an array of Subgraph IDs (comma separated) \e[0m"
              read list
              awk -F',' '{ for( i=1; i<=NF; i++ ) print $i }' <<<"$list" >> offchain-subgraphs;break;;
        No ) break;;
    esac
done
echo -e "\e[1;32m Done 👏 \e[0m"

echo
echo -e "\e[1;32m Should I edit the start file with the changes for you? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
         Yes ) sed -i.backup "s/\(^INDEXER_AGENT_OFFCHAIN_SUBGRAPHS=.*\)/INDEXER_AGENT_OFFCHAIN_SUBGRAPHS=$(cat offchain-subgraphs | sed -z 's/\n/,/g;s/,$/\n/') \\\/" .env;break;;
         No ) exit;;
     esac
 done
 echo -e "\e[1;32m Done 👏 \e[0m"

echo
echo -e "\e[1;32m Should I restart the containers for you so that the changes apply? \e[0m"
select yn in "Yes" "No"; do
    case $yn in
         Yes ) bash start --force-recreate indexer-agent;break;;
         No ) exit;;
     esac
 done
 echo -e "\e[1;32m Done 👏 \e[0m"
