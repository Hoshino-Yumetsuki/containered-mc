FROM python:3.12.2-bookworm

ARG OPEN_JDK_VERSION=17

RUN sed -i 's,http://deb.debian.org/debian-security,https://nexus.alisaqaq.moe/repository/apt-debian-bookworm-security/,g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's,http://deb.debian.org/debian,https://nexus.alisaqaq.moe/repository/apt-debian-bookworm/,g' /etc/apt/sources.list.d/debian.sources
RUN apt update && apt install wget curl git openjdk-${OPEN_JDK_VERSION}-jdk -y

RUN pip config set global.index-url https://nexus.alisaqaq.moe/repository/pypi-public/simple

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
EXPOSE 25565

RUN /usr/bin/mkdir /opt/minecraft
VOLUME [ "/opt/minecraft" ]

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
