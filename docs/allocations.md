#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md) <- you are here
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)




## Managing Allocations

-   To **control** the allocations, we will use the **indexer-cli**
-   To **check** our allocations, we will use the **indexer-cli, other community-made tools, and later on, the Graph Explorer**



### How to check your allocations

Assuming you already have the graph-cli and indexer-cli installed, in the root of the directory, type:

```bash
./shell cli
graph indexer rules get all

```

You will be greeted by this table. By default, it's set to these values below:
![](https://i.imgur.com/rPwX9wL.png)

### What do the table columns mean?

-   `deployment` - can be either **global**, or an **IPFS hash** of a subgraph of your choice
-   `allocationAmount` - refers to the **GRT allocation** that you want to set, either **globally** or for a **specific subgraph**, depending on your preference
-   `parallelAllocations` - influence how many **state channels** the gateways open with you for a deployment, and this in turn affects the max query request rate you can receive
-   `minSignal` - conditional decision basis ruled by the **minimum** Subgraph **Signal**
-   `maxSignal` - conditional decision basis ruled by the **maximum** Subgraph **Signal**
-   `minStake` - conditional decision basis ruled by the **minimum** Subgraph **Stake**
-   `minAverageQueryFees` - conditional decision basis ruled by the **minimum average** of **query fees**
-   `decisionBasis` - dictates the **behavior** of your **rules**




### General caveats

-   Your total stake of a specific subgraph, or globally, will be calculated as follows:

`allocationAmount` x `parallelAllocations` = `totalStake`

*Example:*

`allocationAmount 100` x `parallelAllocations 5` = 500 GRT allocated



-   `decisionBasis` can be of three types: `always` , `never` and `rules`

`decisionBasis always` overrides the conditional decision basis rules that you might have set (minStake, minSignal, etc) and will ensure that your **allocation** is **always active**

`decisionBasis never` same as above, only that it will ensure that your **allocation** is **always inactive**

`decisionBasis rules` will give you the option of using the conditional decision basis




-   `global` rules will have, by default, an `allocationAmount` of `0.01` GRT and `parallelAllocations` set to `2`

This means that by default, every time you set an `allocationAmount` of a specific subgraph, it will inherit `parallelAllocations 2` rule from `global`.

To see the global rules merged into the rest of your allocations table, you can use the following command:

```bash
graph indexer rules get all --merged

```




## How to set allocations?

**Examples:**

**1.**

```bash
graph indexer rules set <IPFS_HASH> allocationAmount 1000 decisionBasis always

```

Assuming the `<IPFS_HASH>` exists on-chain, this will set an `allocationAmount` of `1000 GRT` and will ensure that the subgraph will `always` be allocated, through `decisionBasis always`

**2.**

```bash
graph indexer rules set global allocationAmount 100 parallelAllocations 10 decisionBasis always

```

This command will enable you to automatically allocate `100 GRT` x `10 parallelAllocations` to **all** the subgraphs that exist on-chain, with 10 parallel allocations each

**3.**

```bash
graph indexer rules set <IPFS_HASH> allocationAmount 1337 parallelAllocations 5 minSignal 100 maxSignal 200 decisionBasis rules

```

This command will enable you to use the decision basis conditional rules of minSignal and maxSignal. The subgraph will only get allocated by the Agent IF the network participants have a minimum of 100 signal strength and a maximum of 200 signal strength.

Generally speaking, you'll be good to just use either the first command or the second one, as they're not complicated to understand. Just be aware of the parallelAllocations number.



## How to verify your allocations?

We can use the following command(s) with the indexer-cli:

**This will only display the subgraph-specific allocation rules**

```bash
graph indexer rules get <IPFS_HASH>

```

**This will display the full rules table**

```bash
graph indexer rules get all

```

**This will display the full rules table with the global values merged**

```bash
graph indexer rules get all --merged

```


## What happens after you set your allocations?

The indexer-agent will now start to allocate the amount of GRT that you specified for each subgraph that it finds to be present on-chain.

Depending on how many subgraphs you allocated towards, it will take time for this action to finish.

Keep in mind that the indexer-agent once given the instructions to allocate, it will throw everything in a queue of transactions that you will not be able to close. For example, if you set `global always` then immediately after, you decide to set `global rules` or `never` it will do a full set of transactions for `global always` then go around and deallocate from them with your second transactions. This means that you will likely be facing a lot of delay between the input time and until the actions have finalized on-chain.

A workaround for this is to restart the indexer-agent app/container, as this will reset his internal queue managing system and start with the most fresh data that it has.

Another workaround is to either delete your rules with `graph indexer rules delete <IPFS>`




#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md) <- you are here
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
