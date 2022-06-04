#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md) <- you are here
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)



## Managing cost models
### What are cost models?

Cost models are indexer tools that they can use in order to set a price for the data that they serve.

You cannot earn GRT for the queries that you serve without a cost model.

The cost models are denominated in decimal GRT.

**Cost models can have two parts:**

-   The model — should contain the queries that you want to price
-   The variables — should contain the variables that the queries use

You can either have a static, simple cost model, or you can dive into complicated cost models based on your database access times for different queries that you serve across different subgraphs, etc.

The decision here is totally up to you 🙂

### How does a model look like?

**The easiest cost model you can set, can look something like this:**

```bash
default => price;

or

query {...} => price;

```

**Example — you're serving every query at 0.01 GRT / query**

```bash
default => 0.01;

```

### How to set a default cost model?

Connect to your CLI 

```
./shell cli
```

Create a default cost model by creating a default file using `nano default` and the adding the following to the new file.
```
default => 0.00005;
```
**Note: This will serve each query at 0.00005 GRT / query**

Save and exit the file, then apply this setting to each of your indexed subgraphs
```
graph indexer cost set model <IPFS HASH> default
```

Once you have applied the default cost model to each you can review them by typeing `graph indexer cost get all`


### How do the variables look like?

```json
{                              
  "VALUE-1": "10.0006390502074853",
  "VALUE-2": "5",                 
  "VALUE-3": "3",                
  "VALUE-4": "1"               
}

```

---------------------


#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md) <- you are here
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
