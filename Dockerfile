FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG OPEN_JDK_VERSION=21
ARG PYTHON_VERSION=3.11
ARG PYPI_URL=https://pypi.org/simple

# Set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and install essential packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    ca-certificates \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python3-pip \
    python3-venv \
    build-essential \
    libssl-dev \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Adoptium Temurin JDK for all Java versions
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget apt-transport-https gnupg && \
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - && \
    echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends temurin-${OPEN_JDK_VERSION}-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Python symlinks
RUN ln -fs /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 && \
    ln -fs /usr/bin/python3 /usr/bin/python && \
    ln -fs /usr/bin/pip3 /usr/bin/pip

# Set pip config
RUN pip config set global.index-url ${PYPI_URL}

# Install uv for faster Python package installation
RUN pip install uv

# Install MCDReforged
RUN uv pip install -U mcdreforged

# Create data directory (main Minecraft working directory)
RUN mkdir -p /data

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# Create minecraft directory
RUN mkdir -p /opt/minecraft

# Define volumes
VOLUME [ "/data" ]

# Expose Minecraft port
EXPOSE 25565

# Set environment variables
ENV INSTALL_MCDR=false
ENV CUSTOM_COMMAND=""
ENV UV_LINK_MODE=copy

WORKDIR /data
ENTRYPOINT [ "bash", "/entrypoint.sh" ]
