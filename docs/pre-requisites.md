#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md) <- you are here
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)



## Ethereum Archive Node Specs

Again, as mentioned in the [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md), the setup for the archive node is **not included** in this docker setup.

This section is purely informative.

|         | Minimum Specs   | Recommended Specs | Maxed out Specs   |
| ------- | --------------- | ----------------- | ----------------- |
| CPUs    | 16 vcore        | 32 vcore          | 64 vcore          |
| RAM     | 32 GB           | 64 GB             | 128 GB            |
| Storage | 3 TB SATA SSD   | 5 TB NVME         | 5 TB NVME RAID 10 |

*Note: The 3 TB requirement for storage is the absolute minimum, it needs to be at least SATA SSD as spinning disks as too slow to also serve the RPC data to the Graph stack. Also, only Erigon has that little space required. OE (now deprecated) and GETH all take 10 TB+ at the very minimum, and expanding pretty fast.*


### Archive node options

| Self-hosted        | Trace API | Stable | EIP-1898 | Min Disk Size | Deprecated |
| ------------------ | --------- | ------ | -------- | ------------- |------------|
| OpenEthereum       | yes ✔️     | yes ✔️  | yes ✔️    | 8 TB      |yes ⚠️      |
| GETH               | no ⚠️      | yes ✔️  | yes ✔️    | 8 TB      |no ✔️       |
| Erigon             | yes ✔️     | yes ✔️  | yes ✔️    | 3 TB      |no ✔️       |


| Service Providers (WIP) |
| ----------------------- |
| Infura                             |
| Alchemy                        |
| ChainStack                   |
| Quiknode                      |
| Ankr                              |



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
* curl
* wget
* jq

On a fresh Ubuntu server login via ssh and execute the following commands:

```bash
apt update -y && apt upgrade -y && apt autoremove -y

apt install docker.io docker-compose httpie curl wget git jq nano -y

npm install -g pino-pretty

```

## Optional Software
* NPM (through Node Version Manager)
* Uncomplicated Firewall (ufw)
* pino-pretty

```bash
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# restart or open a new shell/terminal

nvm install node

# restart or open a new shell/terminal

npm install -g pino-pretty

apt install ufw

```

**IMPORTANT:** Make sure you open your ssh port in ufw before starting it. The default installation will try to open port 22 (default), but if you changed it, make sure you open the right port, otherwise you'll be locked out. In case that happens, reboot into rescue-mode and disable ufw.

#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md) <- you are here
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
