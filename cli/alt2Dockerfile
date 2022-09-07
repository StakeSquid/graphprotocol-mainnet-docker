FROM node:16.15-bullseye-slim as build

ENV NODE_ENV production

RUN apt-get update && apt-get install -y build-essential bc git curl httpie jq nano wget bsdmainutils base58 netcat net-tools libsecret-1-dev python2.7 clang cmake

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh && sh /tmp/rustup.sh -y
ENV PATH="/root/.cargo/bin:$PATH"

WORKDIR /root/
RUN git clone -b v0.20.3 https://github.com/graphprotocol/indexer /root/.npm-global/lib/node_modules/@graphprotocol/indexer-cli

WORKDIR /root/.npm-global/lib/node_modules/@graphprotocol/indexer-cli
RUN yarn --global --frozen-lockfile --non-interactive --production=false

RUN ln -s /root/.npm-global/lib/node_modules/@graphprotocol/indexer-cli/packages/indexer-cli/bin/graph-indexer /usr/bin/graph

RUN mkdir -p "/root/.config/graph-cli/"
RUN echo "api = \"http://indexer-agent:8000/\"" >> "/root/.config/graph-cli/indexing.toml"

WORKDIR /root/
ENTRYPOINT ["cat"]
