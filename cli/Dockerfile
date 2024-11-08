# Accept the full base image URL as a build argument
ARG INDEXER_CLI_VERSION=ghcr.io/graphprotocol/indexer-cli:v0.21.6-2
FROM ${INDEXER_CLI_VERSION}

# Switch to root user to run apt-get commands
USER root

# Update and install necessary packages, specify netcat-openbsd explicitly
RUN apt-get update && apt-get install -y \
    build-essential \
    bc \
    git \
    curl \
    httpie \
    jq \
    nano \
    wget \
    bsdmainutils \
    base58 \
    netcat-openbsd \
    net-tools \
    libsecret-1-dev \
    python3

# Create /history directory for bash history persistence
RUN mkdir -p /history && chmod 777 /history

# Create necessary directory for graph-cli configuration
RUN mkdir -p "/root/.config/graph-cli/"

# Add the API configuration to the indexing.toml file
RUN echo "api = \"http://indexer-agent:8000/\"" >> "/root/.config/graph-cli/indexing.toml"

# Append history command to bashrc for history persistence
RUN echo "export PROMPT_COMMAND='history -a' && export HISTFILE=/history/.bash_history" >> "/root/.bashrc"

RUN mkdir -p /root/scripts
WORKDIR /root/scripts

# Override entrypoint to /bin/bash
ENTRYPOINT ["/bin/bash"]

# Default command to keep the container running
CMD ["-c", "tail -f /dev/null"]