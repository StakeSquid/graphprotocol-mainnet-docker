#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md) <- you are here
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)






## Installing pre-requisites


First off, I strongly recommend having either `graph-pino` or `pino-pretty` installed for this.

You will need NPM installed for them to work and be viewable in a more human-esque manner.

```bash
sudo apt install npm -y

```

To install `graph-pino`, you can simply do:

```bash
npm install -g --registry https://registry.npmjs.org/ @graphprotocol/graph-pino

```

To install `pino-pretty`, you can simply do:

```bash
npm install -g pino-pretty

```

And you're done. These two will greatly help you read through the `indexer-agent` and `indexer-service` logs to easily find errors and warning messages that might occur.

## Usage:

#### Graph-pino with Docker

```bash
docker logs indexer-agent --tail 10 -f | graph-pino

```

#### Graph-pino with Journald

```bash
journalctl -fu indexer-agent -n 10 -f | graph-pino

```

#### Pino-pretty with Docker

```bash
docker logs indexer-agent --tail 10 -f | pino-pretty -c -t

```

#### Pino-pretty with Journald

```bash
journalctl -fu indexer-agent -n 10 -f | pino-pretty -c -t

```

:exclamation: **Note:** pino-pretty and graph-pino only work for logs that output json strings (ie. indexer agent and service)

## Printing logs to file

The following examples strip the colors out of pino-pretty, sends the stdout to /dev/null and print the logs into a file without showing you the logs on screen.

#### Pino-pretty with Docker

```bash
docker logs indexer-service 2>&1 | pino-pretty -c -t | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | tee service.log &> /dev/null &
```



#### Pino-pretty with Journald

```bash
journalctl CONTAINER_NAME=indexer-service -o cat 2>&1 | pino-pretty -c -t | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | tee service.log &> /dev/null &
```

If you want to extract specific dates from your logs you can do as follows, where `-S` is the date/hour since, and `-U` is the date/hour until.

```bash
journalctl CONTAINER_NAME=indexer-service -S "20:22:00" -U "20:55:00" -o cat 2>&1 | pino-pretty -c -t | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | tee service.log &> /dev/null &
```





#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md)
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md) <- you are here
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
