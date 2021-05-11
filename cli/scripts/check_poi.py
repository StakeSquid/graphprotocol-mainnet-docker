#!/bin/python3

import base58
import argparse
import sys
import requests
import json
import os
from string import Template
import argparse

graph_endpoint="https://gateway.network.thegraph.com/network"
#Change to your endpoint url
local_index_node_endpoint="http://index-node-0:8030/graphql"
block_hash_endpoint="https://eth-mainnet.alchemyapi.io/v2/demo"
#Change to increase number of poi to check
number_allocation_to_check=10

def to_id(hash):
    bytes_value = base58.b58decode(hash)
    hex_value = bytes_value.hex()
    return "0x"+hex_value[4:]

def to_ipfs_hash(id):
    #https://ethereum.stackexchange.com/questions/17094/how-to-store-ipfs-hash-using-bytes32
    hex_value = bytes.fromhex("1220"+id[2:])
    ipfs_hash = base58.b58encode(hex_value)
    return ipfs_hash.decode("utf-8")

def generate_poi(indexer_id, block_number, block_hash, subgraph_ipfs_hash):
    t = Template("""query MyQuery {
        proofOfIndexing(
          subgraph: "$subgraph_ipfs_hash",
          blockNumber: $block_number,
          blockHash: "$block_hash",
          indexer: "$indexer_id")
       }""")
    query_data = t.substitute(subgraph_ipfs_hash=subgraph_ipfs_hash,
                              block_number=block_number,
                              block_hash=block_hash,
                              indexer_id=indexer_id)
    request = requests.post(local_index_node_endpoint, json={'query': query_data})

    if request.status_code != 200:
        print("error in generate_poi")
        print(request.text)
        os._exit(1)

    json_response = json.loads(request.text)

    if "errors" in json_response:
        print("error in generate_poi")
        print(json_response["errors"])
        os._exit(1)


    return json_response["data"]["proofOfIndexing"]

def get_indexers_poi_epoch(subgraph):
    indexers_poi_epoch = []
    t = Template("""query MyQuery {
      allocations(where: {subgraphDeployment: "$subgraph", status_not: Active}, first: $number_allocation_to_check, orderBy: closedAtEpoch, orderDirection: desc) {
        closedAtEpoch
        indexer {
         id
        }
        poi
      }
    }""")
    query_data = t.substitute(subgraph=subgraph,number_allocation_to_check=number_allocation_to_check)
    request = requests.post(graph_endpoint, json={'query': query_data})

    if request.status_code != 200:
        print("error in get_indexers_poi_epoch")
        print(request.text)
        os._exit(1)

    json_response = json.loads(request.text)

    if "errors" in json_response:
        print("error in get_indexers_poi_epoch")
        print(json_response["errors"])
        os._exit(1)

    for i in json_response["data"]["allocations"]:
        indexers_poi_epoch.append({"indexer_id": i["indexer"]["id"], "epoch": i["closedAtEpoch"], "poi": i["poi"]})

    return indexers_poi_epoch

def get_current_epoch():
    query_data = '{\n graphNetworks {\n currentEpoch \n} \n}'
    request = requests.post(graph_endpoint, json={'query': query_data})

    if request.status_code != 200:
        print("error in get_current_epoch")
        print(request.text)
        os._exit(1)

    json_response = json.loads(request.text)

    if "errors" in json_response:
        print("error in get_current_epoch")
        print(json_response["errors"])
        os._exit(1)

    return json_response["data"]["graphNetworks"][0]["currentEpoch"]

def get_start_block(epoch):
    t = Template('{ epoch(id: $epoch) { startBlock } }')
    query_data = t.substitute(epoch=epoch)
    request = requests.post(graph_endpoint, json={'query': query_data})

    if request.status_code != 200:
        print("error in get_start_block")
        print(request.text)
        os._exit(1)

    json_response = json.loads(request.text)

    if "errors" in json_response:
        print("error in get_start_block")
        print(json_response["errors"])
        os._exit(1)


    return json_response["data"]["epoch"]["startBlock"]

def get_start_block_hash(epoch_start_block):
    payload = {
        "method": "eth_getBlockByNumber",
        "params": ['{}'.format(hex(epoch_start_block)), False],
        "jsonrpc": "2.0",
        "id": 1,
    }

    response = requests.post(block_hash_endpoint, json=payload).json()

    if "error" in response:
        print("error in get_start_block_hash")
        print(response["error"])
        os._exit(1)

    return response["result"]["hash"]

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--subgraph_ipfs_hash', help='subgraph ipfs_hash to analyze', required=True)
    args = parser.parse_args()

    subgraph_ipfs_hash = args.subgraph_ipfs_hash
    print('Start to check POI for subgraph: {}'.format(subgraph_ipfs_hash))

    subgraph_deployment_id = to_id(subgraph_ipfs_hash)
    current_epoch = get_current_epoch()
    print("Current Epoch: {}".format(current_epoch))
    indexers_poi_epoch = get_indexers_poi_epoch(subgraph_deployment_id)

    for i in indexers_poi_epoch:
       start_block = get_start_block(i["epoch"])
       start_block_hash = get_start_block_hash(start_block)
       my_poi = generate_poi(i["indexer_id"], start_block, start_block_hash, subgraph_ipfs_hash)

       print()
       if my_poi != i["poi"]:
         print("FAILED: POI missmatched with indexer {0}. Generated POI: {1} Indexer POI: {2} Allocation was closed in {3} EPOCH". format(i["indexer_id"], my_poi, i["poi"], i["epoch"]))
         print()
       else:
         print("OK: POI matched with indexer {0}. Allocation was closed in {1} EPOCH".format(i["indexer_id"], i["epoch"]))
         print()

