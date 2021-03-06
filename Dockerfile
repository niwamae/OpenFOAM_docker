FROM ubuntu
MAINTAINER Nobuyuki Iwamae

ARG DOCKER_UID=1000
ARG DOCKER_USER=ofuser
ARG DOCKER_PASSWORD=ofuser
ARG DOCKER_HOME=/home/ofuser
ARG OF_ROOT_DIR=/home/ofuser/OpenFOAM

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

RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} -s /bin/bash -d ${DOCKER_HOME} \
&&  echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

USER ${DOCKER_USER}
ENV USER=${DOCKER_USER}
RUN mkdir ${OF_ROOT_DIR} \
&&  curl -SL https://sourceforge.net/projects/openfoam/files/v2012/OpenFOAM-v2012.tgz \
    | tar -xzC ${OF_ROOT_DIR}
WORKDIR ${OF_ROOT_DIR}/OpenFOAM-v2012
RUN . etc/bashrc && ./Allwmake -j 2 && rm -r build/*

RUN mkdir -p ${OF_ROOT_DIR}/ofuser-v2012/run
WORKDIR ${DOCKER_HOME}
COPY --chown=${DOCKER_USER}:${DOCKER_USER} dot.bashrc ${DOCKER_HOME}/.bashrc
