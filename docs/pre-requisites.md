#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/README.md)
- [Pre-requisites](docs/pre-requisites.md) <- you are here
- [Getting Started](docs/getting-started.md)
- [Advanced Configuration](docs/advanced-config.md)
- [Setting Up Allocations](docs/allocations.md)
- [Setting Up Cost Models](docs/costmodels.md)
- [Viewing Logs](docs/logs.md)
- [Tips and Tricks](docs/tips.md)
- [Troubleshooting](docs/troubleshooting.md)



## Ethereum Archive Node Specs

Again, as mentioned in the [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/advanced/README.md), the setup for the archive node is **not included** in this docker setup.

This section is purely informative.

|         | Minimum Specs   | Recommended Specs | Maxed out Specs   |
| ------- | --------------- | ----------------- | ----------------- |
| CPUs    | 16 vcore        | 32 vcore          | 64 vcore          |
| RAM     | 32 GB           | 64 GB             | 128 GB            |
| Storage | 1.5 TB SATA SSD | 8 TB NVME         | 8 TB NVME RAID 10 |

*Note: The 1.5 TB requirement for storage is the absolute minimum, it needs to be at least SATA SSD as it doesn't work with spinning disks. Also, only Erigon has that little space required. OE, Parity and GETH all take 7 TB+ at the very minimum, and expanding pretty fast.*


### Archive node options

| Self-hosted        | Trace API | Stable | EIP-1898 | Min Disk Size |
| ------------------ | --------- | ------ | -------- | ------------- |
| OpenEthereum 3.0.x | yes ✔️     | no ⚠️   | yes ✔️    | 8 TB          |
| OpenEthereum 3.1   | yes ✔️     | no ⚠️   | no ⚠️     | 8 TB          |
| OpenEthereum 3.2   | yes ✔️     | yes ✔️  | yes ✔️    | 8 TB          |
| Parity 2.5.13      | yes ✔️     | yes ✔️  | no ⚠️     | 8 TB          |
| GETH               | no ⚠️      | yes ✔️  | yes ✔️    | 8 TB          |
| Erigon             | yes ✔️     | yes ✔️  | yes ✔️    | 1.5 TB        |


| Service Providers (WIP) |
| ----------------------- |
| Infura                  |
| Alchemy                 |
| ChainStack              |
| Quiknode                |
| Ankr                    |



## Graph Protocol Infrastructure Specs

|         | Minimum Specs   | Recommended Specs | Maxed out Specs    |
| ------- | --------------- | ----------------- | ------------------ |
| CPU     | 16 vcore        | 64 vcore          | 128+ vcore         |
| RAM     | 32 GB           | 128 GB            | 256/512+ GB        |
| Storage | 300 GB SATA SSD | 2 TB NVME         | 8+ TB NVME RAID 10 |

*The specs/requirements listed here come from our own experience during the testnet.*

*Your mileage may vary, so take this with a grain of salt and be ready to upgrade.* :)

- The minimum specs will definitely get you running, but not for long, assuming you want to serve data for more than a few heavy-weight subgraphs in the future.

- The recommended specs are a good setup for those that want to dip more than their feet in the indexing waters. Can serve a decent number of subgraphs, but it's limited by the CPU if too many requests flow through.

- The maxed out specs rule of thumb is basically more is better. More CPUs, more RAM, faster disks. There is never enough. IT...NEEDS....MORE!!!!11

Closing note, regarding the specs mentioned above: ideally, they need to scale up proportional with your stake in the protocol.




## Software Prerequisites

* Docker Engine
* Docker Compose
* git
* httpie
* jq
* npm

On a fresh Ubuntu server login via ssh and execute the following commands:

```bash
apt update -y && apt upgrade -y && apt autoremove -y
apt install docker.io docker-compose httpie git jq npm nano -y
npm install -g pino-pretty

```
