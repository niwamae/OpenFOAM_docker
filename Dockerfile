FROM ubuntu
MAINTAINER Nobuyuki Iwamae

ARG DOCKER_UID=1000
ARG DOCKER_USER=ofuser
ARG DOCKER_PASSWORD=ofuser

RUN apt-get update && apt-get install -y tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/localtime

RUN apt-get update \
&& apt-get install -y zsh vim lv git curl \
                      g++ build-essential flex bison cmake zlib1g-dev \
                      libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin \
                      libreadline-dev libncurses-dev libxt-dev \
                      libscotch-dev libcgal-dev sudo \
&& apt-get clean \
&& rm -rf /var/lib/atp/lists/*

RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} -s /bin/bash -d /home/ofuser \
&&  echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

RUN mkdir /home/ofuser/OpenFOAM \
&&  curl -SL https://sourceforge.net/projects/openfoam/files/v2012/OpenFOAM-v2012.tgz \
    | tar -xzC /home/ofuser/OpenFOAM

# COPY MyFile.txt /root/

USER ${DOCKER_USER}
