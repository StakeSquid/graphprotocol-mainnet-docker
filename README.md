Graph Protocol Mainnet Docker Compose - Advanced Edition 
============



## Welcome to the Advanced Edition ​o​f ​o​ur​ ​M​ai​n​net​ ​rep​os​it​or​y​ :slightly_smiling_face:



#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/README.md) <- you are here
- [Pre-requisites](docs/pre-requisites.md)
- [Getting Started](docs/getting-started.md)
- [Advanced Configuration](docs/advanced-config.md)
- [Setting Up Allocations](docs/allocations.md)
- [Setting Up Cost Models](docs/costmodels.md)
- [Viewing Logs](docs/logs.md)
- [Tips and Tricks](docs/tips.md)
- [Troubleshooting](docs/troubleshooting.md)



This branch is made for people that know what they're doing, and want to achieve more with their graph-nodes than what we provided in the master branch.

If you have any questions or need support, feel free to reach us via Graph's Discord server. But keep in mind that, as a general rule of thumb, we will not provide any sort of support for anything that is already written and explained in the docs section of this repository so please make sure you read *all* the files in the docs folder, then ask questions :slightly_frowning_face:. Chances are your questions or concerns are already covered in the docs.

We may or may not continue to support this branch, so before jumping down the rabbit hole, make sure to check when this branch was last updated, and which version of the software stack is using (ie. graph-node or indexer-agent) and compare them with the [networks.md](https://github.com/graphprotocol/indexer/blob/main/docs/networks.md) in the official graphprotocol repository.

This repository is a one-stop solution to the decentralized world of The Graph. It spins up all the necessary containers on one single machine including monitoring solutions and a CLI container that allows you to interact with the graph-nodes or the indexer-agent.

A monitoring solution for hosting a graph node on a single Docker host with [Prometheus](https://prometheus.io/), [Grafana](http://grafana.org/), [cAdvisor](https://github.com/google/cadvisor),
[NodeExporter](https://github.com/prometheus/node_exporter) and alerting with [AlertManager](https://github.com/prometheus/alertmanager).

The monitoring configuration runs with [Prometheus](https://prometheus.io/), [Grafana](http://grafana.org/), [cAdvisor](https://github.com/google/cadvisor), [NodeExporter](https://github.com/prometheus/node_exporter) and alerting with [AlertManager](https://github.com/prometheus/alertmanager), a K8S template provided by the Graph team in the [mission control repository](https://github.com/graphprotocol/mission-control-indexer) during the testnet, and later adapted for mainnet using [this configuration](https://github.com/graphprotocol/indexer/blob/main/docs/networks.md#mainnet-and-testnet-configuration).

The advantage of using Docker, as opposed to systemd bare-metal setups, is that Docker is easy to manipulate and scale up if needed. We personally ran the whole testnet infrastructure on the same machine, including an Erigon Archive Node (not included in this docker build).

For those that consider running their infras like we did, here are our observations regarding the necessary hardware specs:

> From our experience during the testnet, the heaviest load was put onto Postgres at all times, whilst the other infrastructure parts had little to no load on them at times. Postgres loads the CPU enormously even with all the optimizations in the world. Even our 48 core EPYC was struggling to deliver a steady 100-150 queries per second for Uniswap during the testnet. Smaller subgraphs and less expensive queries will definitely not overload the database that much.

The best part of using Docker is that the data is stored in named volumes on the docker host and can be exported / copied over to a bigger machine once more performance is needed.

Note that you **need** access to an **Ethereum Archive Node that supports EIP-1898**.

The setup for the archive node is **not included** in this docker setup.

The minimum configuration should to be the CPX51 VPS at Hetzner. Feel free to sign up using our [referral link](https://hetzner.cloud/?ref=x2opTk2fg2fM) -- you can save 20€ and we get 10€ bonus for setting up some testnet nodes to support the network growth. :)
