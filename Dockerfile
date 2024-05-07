FROM almalinux:9

ARG OPEN_JDK_VERSION=17
ARG PYTHON_VERSION=3.11
ARG PYPI_URL=https://nexus.alisaqaq.moe/repository/pypi-public/simple
ARG SKIP_ALMALINUX_REPO=false

RUN if [ "$SKIP_ALMALINUX_REPO" = "false" ]; then \
    rm -f /etc/yum.repos.d/* && \
    curl -o /tmp/almalinux.tar https://s3.pikachu.alisaqaq.moe/setup-tools/repos/almalinux/almalinux.tar && \
    tar -xf /tmp/almalinux.tar -C /etc/yum.repos.d/ && \
    rm -f /tmp/almalinux.tar; \
    fi
RUN dnf makecache && dnf update -y && dnf install wget git java-${OPEN_JDK_VERSION}-openjdk python${PYTHON_VERSION} python${PYTHON_VERSION}-pip -y
RUN ln -fs /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 && \
    ln -fs /usr/bin/python${PYTHON_VERSION} /usr/bin/python && \
    ln -fs /usr/bin/pip${PYTHON_VERSION} /usr/bin/pip3 && \
    ln -fs /usr/bin/pip${PYTHON_VERSION} /usr/bin/pip

RUN pip config set global.index-url ${PYPI_URL}

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 25565

ENV INSTALL_MCDR=false

RUN /usr/bin/mkdir /opt/minecraft
VOLUME [ "/opt/minecraft" ]

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
