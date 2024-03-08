FROM git.alisaqaq.moe:443/alisa-lab-containers/dependency_proxy/containers/python:3.12.2-bookworm

ARG OPEN_JDK_VERSION=17

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt update && apt install wget curl git openjdk-${OPEN_JDK_VERSION}-jdk -y

RUN pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple

RUN useradd -m -U -d /home/container container

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
RUN chown container:container /entrypoint.sh

USER container
ENV USER=container
ENV HOME=/home/container

RUN mkdir /home/container/minecraft

WORKDIR /home/container/minecraft

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
