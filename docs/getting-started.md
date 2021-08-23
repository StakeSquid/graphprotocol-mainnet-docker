#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md) <- you are here
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)



## Install from scratch

Run the following commands to clone the repository and set everything up:

```bash
git clone -b advanced git@github.com:StakeSquid/graphprotocol-mainnet-docker.git
cd graphprotocol-mainnet-docker
git submodule init
git submodule update
git config --global user.email "you@example.com"
git config --global user.name "Example User"
git branch --set-upstream-to=origin

```



## Get a domain

To enable SSL on your host you should get a domain.

You can use any domain and any regsitrar that allowes you to edit DNS records to point subdomains to your IP address.

For a free option go to [myFreenom](https://my.freenom.com/) and find a free domain name. Create a account and complete the registration.

In the last step choose "use dns" and enter the IP address of your server. You can choose up to 12 months for free.

Under "Service > My Domains > Manage Domain > Manage Freenom DNS" you can add more subdomains later.

Create 2 subdomains, named as follows:
```
index.sld.tld
grafana.sld.tld
```



## Create a mnemonic

You need a wallet with a seed phrase that is registered as your operator wallet. This wallet will be the one that makes transactions on behalf of your main wallet (which holds and stakes the GRT).

The operator wallet has limited functionality, and it's recommended to be used for security reasons.

*You need a 12-word, or 15-word mnemonic phrase in order for it to work.*

To make yourself a mnemonic eth wallet you can go to this [website](https://iancoleman.io/bip39/), select ETH from the dropdown and press generate.

You get a seed phrase in the input field labeled BIP39 Mnemonic.

You can find your address, public key and private key in the first row of the table if you scroll down the page in the section with the heading "Derived Addresses".

If you need, you can import the wallet using the private key into Metamask



## Run

Navigate to the `graph-node-configs` folder and edit both index-node configs with your Ethereum RPC urls.
Unfortunately these variables cannot be passed yet from the start file.

After that, the root of the repo, edit the file called `start` and add your values to the following envs:

```bash
EMAIL=email@domain.com \
INDEX_HOST=index.sld.tld \
GRAFANA_HOST=grafana.sld.tld \
ADMIN_USER=your_user \
ADMIN_PASSWORD=your_password \
DB_USER=your_db_user \
DB_PASS=your_db_password \
GRAPH_NODE_DB_NAME=your_graphnode_db_name \
AGENT_DB_NAME=your_agent_db_name \
TXN_RPC="http://ip:port" \
OPERATOR_SEED_PHRASE="12 or 15 word mnemonic" \
STAKING_WALLET_ADDRESS=0xAdDreSs \
GEO_COORDINATES="69.420 69.420" \
docker-compose up -d --remove-orphans --build $@

#The following ENV vars are optional
#they need to be added above the last line containing
#docker-compose...

#QUERY_FEE_REBATE_CLAIM_THRESHOLD=1000 \
#INDEXER_AGENT_NETWORK_SUBGRAPH_DEPLOYMENT=QmaUBw7sr8pBrwNgz6JkbmmGoUU7KJSaeRvCaY3NPDbQ7A \
#OFFCHAIN_SUBGRAPHS="QmRhh7rFt3qxfRMTZvHRNK6jCobX4Gx5TkzWXhZkuj57w8,QmTBxvMF6YnbT1eYeRx9XQpH4WvxTV53vdptCCZFiZSprg,QmZdsSbRwVD7VVVm5WGxZZC6HYvbjnFb4hcwvQ4fTs5bxA,QmRhYzT8HEZ9LziQhP6JfNfd4co9A7muUYQhPMJsMUojSF,QmbHg6vAJRD9ZWz5GTP9oMrfDyetnGTr5KWJBYAq59fm1W,Qmf3qbX2SF58ifUQfMvWJKe99g9DavSKtRxm3evvCHocwS,QmRDGLp6BHwiH9HAE2NYEE3f7LrKuRqziHBv76trT4etgU,QmUghXvKf5cVjtayNNRHCd3RbHEwfbGBQ95s9vheJjN5hH,QmTKXLEdMD6Vq7Nwxo8XAfnHpG6H1TzL1AGwiqLpoae3Pb,Qmaz1R8vcv9v3gUfksqiS9JUz7K9G8S5By3JYn8kTiiP5K,QmNRkaVUwUQAwPwWgdQHYvw53A5gh3CP3giWnWQZdA2BTE" \
#GRAPHNODE_LOGLEVEL=warn \
#ETHEREUM_TRACE_STREAM_STEP_SIZE=100 \
#ETHEREUM_BLOCK_BATCH_SIZE=50 \
#ETHEREUM_RPC_MAX_PARALLEL_REQUESTS=128 \
#GRAPH_ETHEREUM_MAX_BLOCK_RANGE_SIZE=1000 \
#GRAPH_ETHEREUM_TARGET_TRIGGERS_PER_BLOCK_RANGE=500 \
#FULLTEXT_SEARCH="true" \




```

**To start the software, just do `bash start`**

`EMAIL` is only used as contact to create SSL certificates. Usually it doesn't receive any emails but is required by the certificate issuer.

`INDEX_HOST` and `GRAFANA_HOST` should point to the subdomains created earlier.

`ADMIN_USER` and `ADMIN_PASSWORD` will be used by Grafana, Prometheus and AlertManager.

`DB_USER` and `DB_PASS` will be used for initializing the PostgreSQL Databases (both index/query DB and indexer agent/service DB).

`GRAPH_NODE_DB_NAME` is the name of the database used by the Index/Query nodes.

`AGENT_DB_NAME` is the name of the database used by the Indexer agent/service nodes.

`TXN_RPC` is your ETH RPC used by Indexer agent/service nodes. This can be a full or fast node, or archive, up to you.

`OPERATOR_SEED_PHRASE` should belong to the operator wallet mnemonic phrase.

`STAKING_WALLET_ADDRESS` needs to be the address that you staked your GRT with.

To find out the `GEO_COORDINATES` you can search for an ip location website and check your server exact coordinates.

Uncomment and edit `QUERY_FEE_REBATE_CLAIM_THRESHOLD` if you want to stop your agent from automatically claiming query fee rebates below a certain GRT threshold.

***YOU MUST SET ALL THE ENVS ABOVE EVEN IF SOME OF THEM WILL HAVE THE SAME VALUES (eg. RPC_0 RPC_1 and TXN_RPC)***

In case something goes wrong try to add `--force-recreate` at the end of the command, eg.: `bash start --force-recreate <container_name>`.

Containers:

* Graph Node (query node)
* Graph Node (index node)
* Indexer Agent
* Indexer Service
* Indexer CLI
* Postgres Database for the index/query nodes
* Postgres Database for the agent/service nodes
* Prometheus (metrics database) `http://<host-ip>:9090`
* Prometheus-Pushgateway (push acceptor for ephemeral and batch jobs) `http://<host-ip>:9091`
* AlertManager (alerts management) `http://<host-ip>:9093`
* Grafana (visualize metrics) `http://<host-ip>:3000`
* NodeExporter (host metrics collector)
* cAdvisor (containers metrics collector)
* Caddy (reverse proxy and basic auth provider for prometheus and alertmanager)



**Additional configs and details:**

- Agent/Service - [networks.md](https://github.com/graphprotocol/indexer/blob/main/docs/networks.md)
- Graph-Node - [environment-variables.md](https://github.com/graphprotocol/graph-node/blob/master/docs/environment-variables.md)



## Indexer Infrastructure Ports

### Ports Overview

The following ports are being used by all components by default. Also listed are
the CLI flags and environment variables that can be used to change the ports.

#### Graphical Overview

![](https://raw.githubusercontent.com/graphprotocol/mission-control-indexer/master/files/ports.png)

#### Graph Node

| Port | Purpose                                    | Routes                                             | CLI argument        | Environment variable |
| ---- | ------------------------------------------ | -------------------------------------------------- | ------------------- | -------------------- |
| 8000 | GraphQL HTTP server (for subgraph queries) | `/subgraphs/id/...` <br/> `subgraphs/name/.../...` | `--http-port`       | -                    |
| 8001 | GraphQL WS (for subgraph subscriptions)    | `/subgraphs/id/...` <br/> `subgraphs/name/.../...` | `--ws-port`         | -                    |
| 8020 | JSON-RPC (for managing deployments)        | `/`                                                | `--admin-port`      | -                    |
| 8030 | Subgraph indexing status API               | `/graphql`                                         | `--index-node-port` | -                    |
| 8040 | Prometheus metrics                         | `/metrics`                                         | `--metrics-port`    | -                    |

#### Indexer Service

| Port | Purpose                                         | Routes                                                              | CLI argument | Environment variable   |
| ---- | ----------------------------------------------- | ------------------------------------------------------------------- | ------------ | ---------------------- |
| 7600 | GraphQL HTTP server (for paid subgraph queries) | `/subgraphs/id/...` <br/> `/status` | `--port`     | `INDEXER_SERVICE_PORT` |
| 7300 | Prometheus metrics                              | `/metrics`                                                          | -            | -                      |

#### Indexer Agent

| Port | Purpose                                      | Routes | CLI argument                | Environment variable                    |
| ---- | -------------------------------------------- | ------ | --------------------------- | --------------------------------------- |
| 8000 | Indexer management API (for `graph indexer`) | `/`    | `--indexer-management-port` | `INDEXER_AGENT_INDEXER_MANAGEMENT_PORT` |



## Install or Update the Agora and Qlog modules

To update those repos to the latest version just do the following command occasionally.

```bash
git submodule update

```



To use qlog or agora execute the `runqlog` or `runagora` scripts in the root of the repository.

```bash
./runagora --help
./runqlog --help

```



This will use the compiled qlog tool and extract queries since yesterday or 5 hours ago and store them to the query-logs folder.

```bash
./extract_queries_since yesterday
./extract_queries_since "5 hours ago"

```



To make journald logs persistent across restarts you need to create a folder for the logs to store in like this:

```
mkdir -p /var/log/journal

```

That's all.





## Updates and Upgrades

The general procedure is the following:

```bash
cd <project-folder>
git fetch
git pull

```

This will update the scripts from the repository.

To upgrade the containers:
```bash
bash start --force-recreate <container-name>

```


To update Agora or Qlog repos to the latest version just do the following command occasionally:

```bash
git submodule update

```


To use qlog or agora execute the `runqlog` or `runagora` scripts in the root of the repository.

```bash
./runagora --help
./runqlog --help

```







#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md) <- you are here
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
