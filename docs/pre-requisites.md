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



## Stake on the Network

In order to become an indexer on the Graph Protocol Network, you'll have to stake a minimum of 100,000 GRT.

This can easily be done via the Web UI, by going to the [Graph Explorer](https://thegraph.com/explorer).

1. Login with Metamask on the Wallet that holds your GRT

2. Go to your Profile, then switch to the "Indexing" Tab and hit "Stake"
![](https://i.ibb.co/4KxB08t/image.png)

3. Stake the amount of GRT that you desire, then you're all done!


## Set your Operator

The Operator is a wallet address that is entirely separate from the address which you staked your GRT from. This Operator wallet will be filled with ETH, and will be used to send transactions (such as allocations) to the network, while keeping your Staked GRT safe in case of an attack on your infrastructure. It is highly recommended for you to use a new wallet, generated from a new mnemonic phrase.

For this, follow the [instructions here](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md#create-a-mnemonic) first, then head back for the rest.

Okay, assuming that you followed the instructions and you have your new Operator wallet at hand, lets go and link it up with the wallet that you used to stake your GRT.

1. Login with Metamask on the wallet that you used to stake your GRT
2. Click the Profile dropdown button, and go to "Settings", and then to the "Operators" tab
![](https://i.ibb.co/4PYjJj0/image.png)
3. Click the Plus (+) button and add your operator public address there
4. Submit the transaction, then you're done




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

apt install docker.io docker-compose httpie curl wget git jq nano apparmor -y

rm -rf $(which envsubst) && curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst && chmod +x envsubst && sudo mv envsubst /usr/bin/envsubst

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
