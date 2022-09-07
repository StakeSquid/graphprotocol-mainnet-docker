FROM rust

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update \
  && apt-get -q -y install --no-install-recommends \
    git \
    httpie \
    curl \
    htop \
    jq \
    mc \
    nano \
    netcat \
    net-tools \
    libsecret-1-dev \
    python2.7 \
    clang \
    cmake \
    wget \
	  bsdmainutils \
	  base58 \
    bc \
    build-essential

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get -q update \
  && apt-get -q -y install --no-install-recommends \
    nodejs httpie


ARG GRAPH_USER=graph
ARG GRAPH_HOME=/home/graph

RUN useradd -m -d "${GRAPH_HOME}" -s /bin/bash "${GRAPH_USER}"

USER $GRAPH_USER
WORKDIR $GRAPH_HOME

RUN npm config set prefix "${GRAPH_HOME}/.npm-global"

# RUN npm i -g npm-cli-login

# ARG NPM_REGISTRY_URL
# ARG NPM_REGISTRY_USERNAME
# ARG NPM_REGISTRY_PASSWORD
# ARG NPM_REGISTRY_EMAIL

RUN export PATH="${GRAPH_HOME}/.npm-global/bin:$PATH"
#  && npm-cli-login \
#    -u "${NPM_REGISTRY_USERNAME}" \
#    -p "${NPM_REGISTRY_PASSWORD}" \
#    -e "${NPM_REGISTRY_EMAIL}" \
#    -r "${NPM_REGISTRY_URL}"




RUN npm install -g yarn

RUN npm install -g nan

RUN npm i -g @graphprotocol/indexer-cli@0.20.3 --registry https://registry.npmjs.org/ --unsafe-perm=true

RUN npm i -g @graphprotocol/graph-cli --registry https://registry.npmjs.org/ --unsafe-perm=true

RUN echo 'export PATH="${HOME}/.npm-global/bin:$PATH"' >> "${GRAPH_HOME}/.bashrc"

RUN mkdir "${GRAPH_HOME}/.config/graph-cli/"

RUN echo 'api = "http://indexer-agent:8000/"' >> "${GRAPH_HOME}/.config/graph-cli/indexing.toml"

ENTRYPOINT [ "cat" ]
