#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md) <- you are here
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)


## Working environment

To open or close allocations, we will be using the `cli` container.

Get into the `cli` container by running the following command inside the root of the repository

```bash
./shell cli

```

Now we have access to both `graph-cli` and the `indexer-cli` as an extension to the former.

To get more information about the available `graph` commands use the following:

```bash
graph --help
graph indexer --help


```



## Understanding Subgraph Allocations

In order to get a better understanding around Subgraph Allocations as an indexer, I would highly recommend reading the following article, written by Jim from WaveFive, along with the Network Overview blogposts written by Brandon.

- https://wavefive.notion.site/The-Graph-Protocol-Indexer-Subgraph-Selection-Guide-725f6e575f6e4024ad7e50f2f4e9bbad
- https://thegraph.com/blog/the-graph-network-in-depth-part-1
- https://thegraph.com/blog/the-graph-network-in-depth-part-2


Without a thorough understanding of the Protocol economics, you won't be profitable. So before jumping to anything else, give those links a read.



## Opening Allocations

Once you read those links above and you know exactly what your plan is, and what you're doing, then make it to the Graph Explorer (https://thegraph.com/explorer), find the subgraphs that you want to allocate towards, and copy their IPFS hash (Deployment ID).

![ipfs_hash](https://i.postimg.cc/NFyqRHY2/image.png)


Now, to allocate towards your chosen subgraph, inside the cli container, run the following command:

```bash
graph indexer rules set <IPFS_HASH> allocationAmount <GRT> decisionBasis always


```

This will trigger the `indexer-agent` to send an allocation transaction on the network, and once that's confirmed, you've successfully allocated to the subgraph of your choice!


## Reviewing your allocations using the indexer-cli

### Review local database of allocations

We can use the following command with the indexer-cli:


```bash
graph indexer rules get all

```

This will give us a table with all the allocations that we've set up. It doesn't check for on-chain allocations, as it's only displaying the allocation rules found in your agent database.

### Check for onchain allocations via the indexer-cli

We can use the following command with the indexer-cli:

```bash
graph indexer status


```

This will give you information about the status of your endpoints, and also display current on-chain allocations and their status.

### Check for onchain allocations via the Graph Explorer and other 3rd party tools

You can easily see if you've successfully allocated to a subgraph by going to your indexer profile on the Graph Explorer, or other 3rd party tools.

- https://thegraph.com/explorer/participants/indexers
- https://graphscan.io/#indexers
- https://www.graphtronauts.com/#/indexers
- https://maplenodes.com/graph/indexers/
- https://indexer-tools.vincenttaglia.com/

You simply have to search for your indexer address (staking wallet) to find out if your allocations are set on-chain.


### Check for onchain allocations via querying the Network Subgraph

Another, more direct, way of checking for successful allocations onchain, would be to query the Network Subgraph for your indexer address, with the following query:

- https://api.thegraph.com/subgraphs/name/graphprotocol/graph-network-mainnet/graphql

```json
query MyQuery {
  allocations(
    where: {activeForIndexer: "<lower_case_address>"}
  ) {
    id
    subgraphDeployment {
      ipfsHash
      originalName
    }
  }
}


```



## Closing allocations

To close allocations, you have two options:

First option would be to run the same command that you used to allocate, but chainging the `decisionBasis` to `never`:

```bash
graph indexer rules set <IPFS_HASH> decisionBasis never


```

This will trigger the `indexer-agent` to send an allocation closure transaction on the network, and once that's confirmed, you've successfully unallocated off that subgraph!

The second option would be to just delete the allocation from the rules database. This also makes things much more nice and tidy, especially if you use the `get rules all` command all the time.

```bash
graph indexer rules delete <IPFS_HASH>


```

Or you can delete all the rules via

```bash
graph indexer rules delete all


```





#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md) <- you are here
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
