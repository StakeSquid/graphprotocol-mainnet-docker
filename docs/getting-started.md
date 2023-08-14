#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md) <- you are here
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)

## Install from scratch

Run the following commands to clone the repository and set everything up:

```bash
git clone git@github.com:StakeSquid/graphprotocol-mainnet-docker.git
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

**_You need a 12-word, or 15-word mnemonic phrase in order for it to work._**

To make yourself a mnemonic eth wallet you can go to this [website](https://iancoleman.io/bip39/), select ETH from the dropdown and press generate.

You get a seed phrase in the input field labeled BIP39 Mnemonic.

You can find your address, public key and private key in the first row of the table if you scroll down the page in the section with the heading "Derived Addresses".

**Make sure you save the mnemonic, private key and the wallet address somewhere safe.**

If you need, you can import the wallet using the private key into Metamask

## Configure the environment variables

Edit the file called `.env` and add your values to the following envs:

```bash
EMAIL=email@sld.tld
INDEX_HOST=index.sld.tld
GRAFANA_HOST=grafana.sld.tld
AGENT_GUI_HOST=agent.sld.tld
ADMIN_USER=your_user
ADMIN_PASSWORD=your_password
DB_USER=your_db_user
DB_PASS=your_db_password
GRAPH_NODE_DB_NAME=your_graphnode_db_name
AGENT_DB_NAME=your_agent_db_name
CHAIN_0_NAME="network-name"
CHAIN_0_RPC="http://ip:port"
TXN_RPC="http://ip:port"
OPERATOR_SEED_PHRASE="12 or 15 word mnemonic"
STAKING_WALLET_ADDRESS=0xAdDreSs
GEO_COORDINATES='69.420 69.420'
INDEXER_AGENT_OFFCHAIN_SUBGRAPHS=""

# Optional env vars depending on which services you use:

### Indexer agent GUI:
# AGENT_GUI_HOST=agent.sld.tld
# NEXTAUTH_SECRET=$(openssl rand -base64 32)

### POIfier
# POIFIER_TOKEN=token

### Graphcast Subgraph Radio
# PRIVATE_KEY=
# GRAPHCAST_NETWORK=
# REGISTRY_SUBGRAPH=
# NETWORK_SUBGRAPH=
# GRAPH_NODE_STATUS_ENDPOINT=
# RUST_LOG=
# INDEXER_ADDRESS=
# METRICS_HOST=

# If you change METRICS_PORT, make sure to also change the subgraph-radio job's targets in
# prometheus/prometheus.yml, from targets: ['subgraph-radio:3010'] to targets: ['subgraph-radio:YOUR_NEW_PORT']
# METRICS_PORT=

# SERVER_PORT=
# ID_VALIDATION=
# COVERAGE=
# PERSISTENCE_FILE_PATH=
```

### Required env vars

- `EMAIL` - only used as contact to create SSL certificates. Usually it doesn't receive any emails but is required by the certificate issuer.
- `INDEX_HOST` - your indexer public endpoint. The gateway will be sending queries to this endpoint.
- `GRAFANA_HOST` - your Grafana dashboard for indexer stack monitoring.
- `ADMIN_USER` and `ADMIN_PASSWORD` - will be used by Grafana, Prometheus and AlertManager.
- `DB_USER` and `DB_PASS` - will be used for initializing the PostgreSQL Databases (both index/query DB and indexer agent/service DB).
- `GRAPH_NODE_DB_NAME` - the name of the database used by the Index/Query nodes.
- `AGENT_DB_NAME` - the name of the database used by the Indexer agent/service nodes.
- `CHAIN_0_NAME` - the name of the network that you want to index
- `CHAIN_0_RPC` - your RPCs (archive nodes) used by the index nodes.
- `TXN_RPC` - your Goerli ETH RPC used by Indexer agent/service nodes. This can be a fast/full/archive node, up to you! Please note that using Erigon as the TXN_RPC has proven unreliable by some indexers.
- `OPERATOR_SEED_PHRASE` - the 12/15 word mnemonic that you generated earlier. Will be used by the Agent/Service to send transactions (open/close allocations, etc)
- `STAKING_WALLET_ADDRESS` - the address (0x...) that you staked your GRT with, ideally living on an entirely different mnemonic phrase than your Operator Wallet.
- `GEO_COORDINATES` of your server - you can search for an ip location website and check your server exact coordinates.

### Optional env vars

**Note:** If you want to use any of the optional env vars, you need to copy the line that you want to enable above the last line, and uncomment it.

#### Agent GUI

- `AGENT_GUI_HOST` - your Agent GUI endpoint for controlling the Agent and allocations remotely
- `NEXTAUTH_SECRET` - used by the Agent GUI to salt your password

#### POIfier

- `POIFIER_TOKEN` - Auth token for POIfier-client

#### Graphcast Subgraph Radio

There are a number of optional env vars available to configure [Subgraph Radio](https://github.com/graphops/subgraph-radio), you can learn more about them [here](https://docs.graphops.xyz/graphcast/radios/subgraph-radio#basic-configuration).

## Supporting multiple chains

To add support for multiple chains, you need to edit the [config.tmpl](https://github.com/StakeSquid/graphprotocol-testnet-docker/blob/master/graph-node-configs/config.tmpl) file yourself.

For each chain you wish to support, you need to add the corresponding provider line.

**Example:**

By default, we only support one chain:

```toml
[chains.${CHAIN_0_NAME}]
shard = "primary"
provider = [ { label = "${CHAIN_0_NAME}", url = "${CHAIN_0_RPC}", features = ["archive", "traces"] } ]
```

To add another one, simply duplicate this, and increment the chain number:

```toml
[chains.${CHAIN_0_NAME}]
shard = "primary"
provider = [ { label = "${CHAIN_0_NAME}", url = "${CHAIN_0_RPC}", features = ["archive", "traces"] } ]

[chains.${CHAIN_1_NAME}]
shard = "primary"
provider = [ { label = "${CHAIN_1_NAME}", url = "${CHAIN_1_RPC}", features = ["archive", "traces"] } ]
```

After this, all you have to do is to include in the [.env file](https://github.com/StakeSquid/graphprotocol-testnet-docker/blob/master/.env) your new environment variables.

**Example:**

```
CHAIN_0_NAME="gnosis"
CHAIN_0_RPC="http://ip:port"
CHAIN_1_NAME="matic"
CHAIN_1_RPC="http://ip:port"
```

**Additional configs and details:**

- Agent/Service - [networks.md](https://github.com/graphprotocol/indexer/blob/main/docs/networks.md)
- Graph-Node - [environment-variables.md](https://github.com/graphprotocol/graph-node/blob/master/docs/environment-variables.md)

## Containers in each configuration:

**Graphnode Stack:**

- Index Node
- Query Node
- Postgres Database for the Graphnode Stack

**Indexer Stack:**

- Indexer Agent
- Indexer Service
- Indexer CLI
- Nginx Proxy
- Nginx SSL
- Posgres Database for the Indexer Stack
- [Subgraph Radio](https://docs.graphops.xyz/graphcast/radios/subgraph-radio)

**Autoagora Stack:**

- Indexer Service
- Rabbitmq
- Autoagora Processor
- Autoagora
- Nginx Proxy
- Nginx SSL
- Posgres Database for the Indexer Stack
- Posgres Database for the Autoagora Stack

**Monitoring Stack:**

- Prometheus
- Grafana
- Alertmanager
- Node exporter
- Cadvisor
- Pushgateway
- Nginx Proxy
- Nginx SSL

**Optional Stack:**

- Poifier client
- Indexer Agent GUI
- Nginx Proxy
- Nginx SSL

## Start

Start by picking up the right stack that you want to spin up.

There are several start files used to spin up different components.

I would recommend to start with:

```bash
bash start-essential

```

Be aware that initially it takes several minutes to download and run all the containers (especially the cli container, that one takes a while to build), so be patient. :)

Subsequent restarts will be much faster.

In case something goes wrong, find the problem, edit the variables, and add `--force-recreate` at the end of the command, plus the container you want to recreate:

```bash
bash start-essential --force-recreate <container_name>

```

Or to recreate the entire stack:

```bash
bash start-essential --force-recreate

```

### Start file variants:

**start-essential** - starts up the graphnode, indexer and monitoring stack - all you need to get up and running on the network

**start-optional** - starts up the optional stack (for components, read above)

**start-autoagora** - starts up the autoagora stack (for components, read above)

**start-all** - starts up the entire stack

## Verify that it runs properly

To verify that everything is up and running, you need to:

```bash
docker ps

```

And look for containers that are crash looping - you will notice `restarting` and a countdown - that means those containers are not working properly.

To further debug, try looking for the container logs and see what they say.
More information in the [troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md) section.

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

| Port | Purpose                                         | Routes                              | CLI argument | Environment variable   |
| ---- | ----------------------------------------------- | ----------------------------------- | ------------ | ---------------------- |
| 7600 | GraphQL HTTP server (for paid subgraph queries) | `/subgraphs/id/...` <br/> `/status` | `--port`     | `INDEXER_SERVICE_PORT` |
| 7300 | Prometheus metrics                              | `/metrics`                          | -            | -                      |

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
bash start --force-recreate

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
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
