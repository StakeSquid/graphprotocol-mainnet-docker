Graph Protocol Mainnet Docker Compose
============



This repository is a one-stop solution to the decentralized world of The Graph. It spins up all the necessary containers on one single machine including monitoring solutions and a CLI container that allows you to interact with the graph-nodes or the indexer-agent.

⚠️ **WARNING:** It is very important to read the entire documentation if you want to thoroughly understand the ins and outs of the Indexer Software Stack. If you're trying to binge through this documentation, no help will be offered, and you'll be sent back to **RTFM**. Thanks for understanding. 💖


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



## Table of contents


- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md) <- you are here
- [Pre-requisites](docs/pre-requisites.md)
- [Getting Started](docs/getting-started.md)
- [Advanced Configuration](docs/advanced-config.md)
- [Setting Up Allocations](docs/allocations.md)
- [Setting Up Cost Models](docs/costmodels.md)
- [Tips and Tricks](docs/tips.md)
- [Troubleshooting](docs/troubleshooting.md)
