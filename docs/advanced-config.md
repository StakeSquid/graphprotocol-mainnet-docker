#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md) <- you are here
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)















## Building Postgres outside of Docker



In the [build-postgres](https://github.com/StakeSquid/graphprotocol-mainnet-docker/tree/master/build-postgres) folder you'll see a bunch of scripts. We highly recommend reading them to understand what they're all doing, first of all, then proceed with the installation.



### Compile and run postgres outside of docker

Execute the bash files in the build-postgres folder in the below order and read and follow the printed out instructions carefully.
In case of errors you will have to understand roughly what happens in the scripts to resolve them.

***Note:*** The scripts assume you are running ubuntu.

***IMPORTANT:*** If you have a custom ssh port, change it in `2_configure.sh`

```bash
cd build-postgres
./1_compile.sh
./2_configure.sh
./3_optimize.sh
./start.sh
# ./stop.sh
```

This will take some minutes and needs you to edit several text files and change the system configuration.

Add the following in front of you usual docker-compose up -d startup command that contains all your other environment variables

```bash
DB_HOST=$(ifconfig docker0 | awk '$1 == "inet" {print $2}')
```

It will set the internal ip address that allows docker containers to reach the postgres database running on the host

Note that your postgres will automatically come back up on system startup. It will be started by systemd on every reboot.







-------------------------------

------------------------------

----------------



## Advanced Graph Node configuration

In the [graph-node-configs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/tree/graph-node-configs) folder you can see a few configuration files specific to each graph-node you are running (by default, two index nodes and one query node).

The configs are basic, and work by default just like before. They're loaded as volumes in `/root/graph-node-configs/` inside the Graph Node containers, and passed as flags `GRAPH_NODE_CONFIG=` in the compose file under each Graph Node component.

Configuring your Graph Nodes this way allows you to do a lot more than through having simple flags in the startup of your nodes. For example, this enables you to be able to spin up database shards, organize your subgraph according to your needs and also enables the use of `graphman`, a very powerful utility that everyone should master.

The following section was taken from the Graph Node [config.md](https://github.com/graphprotocol/graph-node/blob/master/docs/config.md) written by the team. Although we will try to keep this section up to date, it might lag behind the changes in the main repo, so please refer to the original guide to see if there are any breaking changes.

# Advanced Graph Node configuration

**This feature is considered experimental. In particular, the format of the configuration file might still change in backwards-incompatible ways**

A TOML configuration file can be used to set more complex configurations than those exposed in the
CLI. The location of the file is passed with the `--config` command line switch. When using a
configuration file, it is not possible to use the options `--postgres-url`,
`--postgres-secondary-hosts`, and `--postgres-host-weights`.

The TOML file consists of four sections:
* `[chains]` sets the endpoints to blockchain clients.
* `[store]` describes the available databases.
* `[ingestor]` sets the name of the node responsible for block ingestion.
* `[deployment]` describes how to place newly deployed subgraphs.

## Configuring Multiple Databases

For most use cases, a single Postgres database is sufficient to support a
`graph-node` instance. When a `graph-node` instance outgrows a single
Postgres database, it is possible to split the storage of `graph-node`'s
data across multiple Postgres databases. All databases together form the
store of the `graph-node` instance. Each individual database is called a
_shard_.

The `[store]` section must always have a primary shard configured, which
must be called `primary`. Each shard can have additional read replicas that
are used for responding to queries. Only queries are processed by read
replicas. Indexing and block ingestion will always use the main database.

Any number of additional shards, with their own read replicas, can also be
configured. When read replicas are used, query traffic is split between the
main database and the replicas according to their weights. In the example
below, for the primary shard, no queries will be sent to the main database,
and the replicas will receive 50% of the traffic each. In the `vip` shard,
50% of the traffic goes to the main database, and 50% to the replica.

```toml
[store]
[store.primary]
connection = "postgresql://graph:${PGPASSWORD}@primary/graph"
weight = 0
pool_size = 10
[store.primary.replicas.repl1]
connection = "postgresql://graph:${PGPASSWORD}@primary-repl1/graph"
weight = 1
[store.primary.replicas.repl2]
connection = "postgresql://graph:${PGPASSWORD}@primary-repl2/graph"
weight = 1

[store.vip]
connection = "postgresql://graph:${PGPASSWORD}@${VIP_MAIN}/graph"
weight = 1
pool_size = 10
[store.vip.replicas.repl1]
connection = "postgresql://graph:${PGPASSWORD}@${VIP_REPL1}/graph"
weight = 1
```

The `connection` string must be a valid [libpq connection
string](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING). Before
passing the connection string to Postgres, environment variables embedded
in the string are expanded.

### Setting the `pool_size`

Each shard must indicate how many database connections each `graph-node`
instance should keep in its connection pool for that database. For
replicas, the pool size defaults to the pool size of the main database, but
can also be set explicitly. Such a setting replaces the setting from the
main database.

The `pool_size` can either be a number like in the example above, in which
case any `graph-node` instance will use a connection pool of that size, or a set
of rules that uses different sizes for different `graph-node` instances,
keyed off the `node_id` set on the command line. When using rules, the
`pool_size` is set like this:

```toml
pool_size = [
  { node = "index_node_general_.*", size = 20 },
  { node = "index_node_special_.*", size = 30 },
  { node = "query_node_.*", size = 80 }
]
```

Each rule consists of a regular expression `node` and the size that should
be used if the current instance's `node_id` matches that regular
expression. You can use the command `graphman config pools` to check how
many connections each `graph-node` instance will use, and how many database
connections will be opened by all `graph-node` instance. The rules are
checked in the order in which they are written, and the first one that
matches is used. It is an error if no rule matches.

It is highly recommended to run `graphman config pools $all_nodes` every
time the configuration is changed to make sure that the connection pools
are what is expected. Here, `$all_nodes` should be a list of all the node
names that will use this configuration file.

## Configuring Ethereum Providers

The `[chains]` section controls the ethereum providers that `graph-node`
connects to, and where blocks and other metadata for each chain are
stored. The section consists of the name of the node doing block ingestion
(currently not used), and a list of chains. The configuration for a chain
`name` is specified in the section `[chains.<name>]`, and consists of the
`shard` where chain data is stored and a list of providers for that
chain. For each provider, the following information must be given:

* `label`: a label that is used when logging information about that
  provider (not implemented yet)
* `transport`: one of `rpc`, `ws`, and `ipc`. Defaults to `rpc`.
* `url`: the URL for the provider
* `features`: an array of features that the provider supports, either empty
  or any combination of `traces` and `archive`
* `headers`: HTTP headers to be added on every request. Defaults to none.

The following example configures two chains, `mainnet` and `kovan`, where
blocks for `mainnet` are stored in the `vip` shard and blocks for `kovan`
are stored in the primary shard. The `mainnet` chain can use two different
providers, whereas `kovan` only has one provider.

```toml
[chains]
ingestor = "block_ingestor_node"
[chains.mainnet]
shard = "vip"
provider = [
  { label = "mainnet1", url = "http://..", features = [], headers = { Authorization = "Bearer foo" } },
  { label = "mainnet2", url = "http://..", features = [ "archive", "traces" ] }
]
[chains.kovan]
shard = "primary"
provider = [ { label = "kovan", url = "http://..", features = [] } ]
```

## Controlling Deployment

When `graph-node` receives a request to deploy a new subgraph deployment,
it needs to decide in which shard to store the data for the deployment, and
which of any number of nodes connected to the store should index the
deployment. That decision is based on a number of rules defined in the
`[deployment]` section. Deployment rules can match on the subgraph name and
the network that the deployment is indexing.

Rules are evaluated in order, and the first rule that matches determines
where the deployment is placed. The `match` element of a rule can have a
`name`, a [regular expression](https://docs.rs/regex/1.4.2/regex/#syntax)
that is matched against the subgraph name for the deployment, and a
`network` name that is compared to the network that the new deployment
indexes. The `network` name can either be a string, or a list of strings.

The last rule must not have a `match` statement to make sure that there is
always some shard and some indexer that will work on a deployment.

The rule indicates the name of the `shard` where the data for the
deployment should be stored, which defaults to `primary`, and a list of
`indexers`. For the matching rule, one indexer is chosen from the
`indexers` list so that deployments are spread evenly across all the nodes
mentioned in `indexers`. The names for the indexers must be the same names
that are passed with `--node-id` when those index nodes are started.

Instead of a fixed `shard`, it is also possible to use a list of `shards`;
in that case, the system uses the shard from the given list with the fewest
active deployments in it.

```toml
[deployment]
[[deployment.rule]]
match = { name = "(vip|important)/.*" }
shard = "vip"
indexers = [ "index_node_vip_0", "index_node_vip_1" ]
[[deployment.rule]]
match = { network = "kovan" }
# No shard, so we use the default shard called 'primary'
indexers = [ "index_node_kovan_0" ]
[[deployment.rule]]
match = { network = [ "xdai", "poa-core" ] }
indexers = [ "index_node_other_0" ]
[[deployment.rule]]
# There's no 'match', so any subgraph matches
shards = [ "sharda", "shardb" ]
indexers = [
    "index_node_community_0",
    "index_node_community_1",
    "index_node_community_2",
    "index_node_community_3",
    "index_node_community_4",
    "index_node_community_5"
  ]

```

## Query nodes

Nodes can be configured to explicitly be query nodes by including the
following in the configuration file:
```toml
[general]
query = "<regular expression>"
```

Any node whose `--node-id` matches the regular expression will be set up to
only respond to queries. For now, that only means that the node will not
try to connect to any of the configured Ethereum providers.

## Basic Setup

The following file is equivalent to using the `--postgres-url` command line
option:
```toml
[store]
[store.primary]
connection="<.. postgres-url argument ..>"
[deployment]
[[deployment.rule]]
indexers = [ "<.. list of all indexing nodes ..>" ]
```

## Validating configuration files

A configuration file can be checked for validity by passing the `--check-config`
flag to `graph-node`. The command
```shell
graph-node --config $CONFIG_FILE --check-config
```
will read the configuration file and print information about syntax errors or, for
valid files, a JSON representation of the configuration.

## Simulating deployment placement

Given a configuration file, placement of newly deployed subgraphs can be
simulated with
```shell
graphman --config $CONFIG_FILE config place some/subgraph mainnet
```
The command will not make any changes, but simply print where that subgraph
would be placed. The output will indicate the database shard that will hold
the subgraph's data, and a list of indexing nodes that could be used for
indexing that subgraph. During deployment, `graph-node` chooses the indexing
nodes with the fewest subgraphs currently assigned from that list.




-----------------

------------------

------------------





## Configuring UFW to work with Docker



### TL;DR

Please take a look at [Solving UFW and Docker issues](#solving-ufw-and-docker-issues).

### Problem

UFW is a popular iptables front end on Ubuntu that makes it easy to manage firewall rules. But when Docker is installed, Docker bypass the UFW rules and the published ports can be accessed from outside.

The issue is:

1. UFW is enabled on a server that provides external services, and all incoming connections that are not allowed are blocked by default.
2. Run a Docker container on the server and use the `-p` option to publish ports for that container on all IP addresses.
   For example: `docker run -d --name httpd -p 0.0.0.0:8080:80 httpd:alpine`, this command will run an httpd service and publish port 80 of the container to port 8080 of the server.
3. UFW will not block all external requests to visit port 8080. Even the command `ufw deny 8080` will not prevent external access to this port.
4. This problem is actually quite serious, which means that a port that was originally intended to provide services internally is exposed to the public network.

Searching for "ufw docker" on the web can find a lot of discussion:

- https://github.com/moby/moby/issues/4737
- https://forums.docker.com/t/running-multiple-docker-containers-with-ufw-and-iptables-false/8953
- https://www.techrepublic.com/article/how-to-fix-the-docker-and-ufw-security-flaw/
- https://blog.viktorpetersson.com/2014/11/03/the-dangers-of-ufw-docker.html
- https://askubuntu.com/questions/652556/uncomplicated-firewall-ufw-is-not-blocking-anything-when-using-docker
- https://chjdev.com/2016/06/08/docker-ufw/
- https://askubuntu.com/questions/652556/uncomplicated-firewall-ufw-is-not-blocking-anything-when-using-docker
- https://my.oschina.net/abcfy2/blog/539485
- https://www.v2ex.com/amp/t/466666
- https://blog.36web.rocks/2016/07/08/docker-behind-ufw.html
- ...

Almost all of these solutions are similar. It requires to disable docker's iptables function first, but this also means that we give up docker's network management function. This causes containers will not be able to access the external network. It is also mentioned in some articles that you can manually add some rules in the UFW configuration file, such as `-A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE`. But this only allows containers that belong to network `172.17.0.0/16` can access outside. If we create a new docker network, we must manually add such similar iptables rules for the new network.

### Expected goal

The solutions that we can find on internet are very similar and not elegant, I hope a new solution can:

- Don't need to disable Docker's iptables and let Docker to manage it's network.
  We don't need to manually maintain iptables rules for any new Docker networks, and avoid potential side effects after disabling iptables in Docker.
- The public network cannot access ports that published by Docker. Even if the port is published on all IP addresses using an option like `-p 8080:80`. Containers and internal networks can visit each other normally.
  Although it is possible to have Docker publish a container's port to the server's private IP address, the port will not be accessed on the public network. But, this server may have multiple private IP addresses, and these private IP addresses may also change.
- In a very convenient way to allow/deny public networks to access container ports without additional software and extra configurations. Just like using command `ufw allow 8080` to allow external access port 8080, then using command `ufw delete allow 8080` to deny public networks visit port 8080.

### How to do?

#### Revoke the original modification

If you have modified your server according to the current solution that we find on the internet, please rollback these changes first, including:

- Enable Docker's iptables feature.
  Remove all changes like `--iptables=false` , including configuration file `/etc/docker/daemon.json`.
- UFW's default FORWARD rule changes back to the default DROP instead of ACCEPT.
- Remove the rules related to the Docker network in the UFW configuration file `/etc/ufw/after.rules`.
- If you have modified Docker configuration files, restart Docker first. We will modify the UFW configuration later and we can restart it then.

#### Solving UFW and Docker issues

This solution needs to modify only one UFW configuration file, all Docker configurations and options remain the default.

Modify the UFW configuration file `/etc/ufw/after.rules` and add the following rules at the end of the file:

    # BEGIN UFW AND DOCKER
    *filter
    :ufw-user-forward - [0:0]
    :ufw-docker-logging-deny - [0:0]
    :DOCKER-USER - [0:0]
    -A DOCKER-USER -j ufw-user-forward

    -A DOCKER-USER -j RETURN -s 10.0.0.0/8
    -A DOCKER-USER -j RETURN -s 172.16.0.0/12
    -A DOCKER-USER -j RETURN -s 192.168.0.0/16

    -A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN

    -A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
    -A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
    -A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
    -A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
    -A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
    -A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

    -A DOCKER-USER -j RETURN

    -A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
    -A ufw-docker-logging-deny -j DROP

    COMMIT
    # END UFW AND DOCKER

Using command `sudo systemctl restart ufw` or `sudo ufw reload` to restart UFW after changing the file. Now the public network can't access any published docker ports, the container and the private network can visit each other normally, and the containers can also access the external network from inside. **There may be some unknown reasons cause the UFW rules will not take effect after restart UFW, please reboot servers.**

If you want to allow public networks to access the services provided by the Docker container, for example, the service port of a container is `80`. Run the following command to allow the public networks to access this service:

    ufw route allow proto tcp from any to any port 80

This allows the public network to access all published ports whose container port is `80`. If you are serving traffic over https then you need to also run the rule again with `port 443`.

Note: If we publish a port by using option `-p 8080:80`, we should use the container port `80`, not the host port `8080`.

If there are multiple containers with a service port of `80`, but we only want the external network to access a certain container. For example, if the private address of the container is `172.17.0.2`, use the following command:

    ufw route allow proto tcp from any to 172.17.0.2 port 80

If the network protocol of a service is UDP, for example a DNS service, you can use the following command to allow the external network to access all published DNS services:

    ufw route allow proto udp from any to any port 53

Similarly, if only for a specific container, such as IP address `172.17.0.2`:

    ufw route allow proto udp from any to 172.17.0.2 port 53

### How it works?

The following rules allow the private networks to be able to visit each other. Normally, private networks are more trusted than public networks.

    -A DOCKER-USER -j RETURN -s 10.0.0.0/8
    -A DOCKER-USER -j RETURN -s 172.16.0.0/12
    -A DOCKER-USER -j RETURN -s 192.168.0.0/16

The following rules allow UFW to manage whether the public networks are allowed to visit the services provided by the Docker container. So that we can manage all firewall rules in one place.

    -A DOCKER-USER -j ufw-user-forward

For example, we want to block all outgoing connections from inside a container whose IP address is 172.17.0.9 which means to block this container to access internet or external networks. Using the following command:

    ufw route deny from 172.17.0.9 to any

The following rules block connection requests initiated by all public networks, but allow internal networks to access external networks. For TCP protocol, it prevents from actively establishing a TCP connection from public networks. For UDP protocol, all accesses to ports which is less then 32767 are blocked. Why is this port? Since the UDP protocol is stateless, it is not possible to block the handshake signal that initiates the connection request as TCP does. For GNU/Linux we can find the local port range in the file `/proc/sys/net/ipv4/ip_local_port_range`. The default range is `32768 60999`. When accessing a UDP protocol service from a running container, the local port will be randomly selected one from the port range, and the server will return the data to this random port. Therefore, we can assume that the listening port of the UDP protocol inside all containers are less then `32768`. This is the reason that we don't want public networks to access the UDP ports that less then `32768`.

    -A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
    -A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
    -A DOCKER-USER -j DROP -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
    -A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
    -A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
    -A DOCKER-USER -j DROP -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

    -A DOCKER-USER -j RETURN

If a docker container doesn't follow the OS's settings when receiving data, that is to say, the minimal port number less than `32768`. For example, we have a Dnsmasq container. The minimal port number that Dnsmasq uses for receiving data is `1024`. We can use the following command to allow a bigger port range used for receiving DNS packages.

    ufw route allow proto udp from any port 53 to any port 1024:65535

Because DNS is a very common service, so there is already a firewall rule to allow a bigger port range to receive DNS packages.

### The reason for choosing `ufw-user-forward`, not `ufw-user-input`

#### using `ufw-user-input`

Pro:

Easy to use and understand, supports older versions of Ubuntu.

For example, to allow the public to visit a published port whose container port is `8080`, use the command:

    ufw allow 8080

Con:

It not only exposes ports of containers but also exposes ports of the host.

For example, if a service is running on the host, and the port is `8080`. The command `ufw allow 8080` allows the public network to visit the service and all published ports whose containers' port is `8080`. But we just want to expose the service running on the host, or just the service running inside containers, not the both.

To avoid this problem, we may need to use a command similar to the following for all containers:

    ufw allow proto tcp from any to 172.16.0.3 port 8080

#### using `ufw-user-forward`

Pro:

Cannot expose services running on hosts and containers at the same time by the same command.

For example, if we want to publish the port `8080` of containers, use the following command:

    ufw route allow 8080

The public network can access all published ports whose container ports are `8080`.

But the port `8080` of the host is still not be accessed by the public network. If we want to do so, execute the following command to allow the public access the port on the host separately:

    ufw allow 8080


Con:

Doesn't support older versions of Ubuntu, and the command is a bit more complicated. But you can use my script.


#### Conclusion

If we are using an older version of Ubuntu, we can use `ufw-user-input` chain. But be careful to avoid exposing services that should not be exposed

If we are using a newer version of Ubuntu which is support `ufw route` sub-command, we'd better use `ufw-user-forward` chain, and use `ufw route` command to manage firewall rules for containers.

### `ufw-docker` util

This script also supports Docker Swarm mode.

#### Install

Download `ufw-docker` script

    sudo wget -O /usr/local/bin/ufw-docker \
      https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
    sudo chmod +x /usr/local/bin/ufw-docker

Then using the following command to modify the `after.rules` file of `ufw`

    ufw-docker install

This command does the following things:
- Back up the file `/etc/ufw/after.rules`
- Append the rules of UFW and Docker at the end of the file

##### Install for Docker Swarm mode

We can only use this script on manager nodes to manage firewall rules when using in Swarm mode.

- Modifying all `after.rules` files on all nodes, including managers and workers
- Deploying this script on manager nodes

Running in Docker Swarm mode, this script will add a global service `ufw-docker-agent`. The image [chaifeng/ufw-docker-agent](https://hub.docker.com/r/chaifeng/ufw-docker-agent/) is also automatically built from this project.

#### Usage

Show help

    ufw-docker help

Check the installation of firewall rules in UFW configurations

    ufw-docker check

Update UFW configurations, add the necessary firewall rules

    ufw-docker install

Show the current firewall allowed forward rules

    ufw-docker status

List all firewall rules related to container `httpd`

    ufw-docker list httpd

Expose the port `80` of the container `httpd`

    ufw-docker allow httpd 80

Expose the `443` port of the container `httpd` and the protocol is `tcp`

    ufw-docker allow httpd 443/tcp

Expose all published ports of the container `httpd`

    ufw-docker allow httpd

Remove all rules related to the container `httpd`

    ufw-docker delete allow httpd

Remove the rule which port is `443` and protocol is `tcp` for the container `httpd`

    ufw-docker delete allow httpd 443/tcp

Expose the port `80` of the service `web`

    docker service create --name web --publish 8080:80 httpd:alpine

    ufw-docker service allow web 80
    # or
    ufw-docker service allow web 80/tcp

Remove rules from all nodes related to the service `web`

    ufw-docker service delete allow web

#### Try it out

We use [Vagrant](https://www.vagrantup.com/) to set up a local testing environment.

Run the following command to create 1 master node and 2 worker nodes

    vagrant up

Log into the master node

    vagrant ssh master

After logging in, create a `web` service

    docker service create --name web --publish 8080:80 httpd:alpine

We shouldn't visit this `web` service from our host

    curl -v http://192.168.56.131:8080

On the master node, run the command to allow the public access port `80` of the `web` service.

    sudo ufw-docker service allow web 80

We can access the `web` service from our host now

    curl "http://192.168.56.13{0,1,2}:8080"

### Discussions

- [What is the best practice of docker + ufw under Ubuntu - Stack Overflow](https://stackoverflow.com/questions/30383845/what-is-the-best-practice-of-docker-ufw-under-ubuntu/51741599#comment91451547_51741599)
- [docker and ufw serious problems · Issue #4737 · moby/moby](https://github.com/moby/moby/issues/4737#issuecomment-420112149)


--------------------
--------------------
--------------------


#### Table of contents

- [README.md](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/README.md)
- [Pre-requisites](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/pre-requisites.md)
- [Getting Started](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/getting-started.md)
- [Advanced Configuration](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/advanced-config.md) <- you are here
- [Setting Up Allocations](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/allocations.md)
- [Setting Up Cost Models](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/costmodels.md)
- [Viewing Logs](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/logs.md)
- [Tips and Tricks](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/tips.md)
- [Troubleshooting](https://github.com/StakeSquid/graphprotocol-mainnet-docker/blob/master/docs/troubleshooting.md)
