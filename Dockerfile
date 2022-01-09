FROM continuumio/miniconda3:4.10.3

RUN apt update && \
    apt install unzip -y

RUN conda install -n base -y -c conda-forge mamba && \
    mamba clean -ya

WORKDIR /home

COPY ./environment.yaml ./

RUN mamba env update -n base --file ./environment.yaml && \
    mamba clean -ya 

ARG CLIP_HASH_VERSION=573315e83f07b53a61ff5098757e8fc885f1703e

RUN git clone --single-branch https://github.com/openai/CLIP.git && \
    cd ./CLIP && \
    git checkout ${CLIP_HASH_VERSION} && \
    pip install --no-cache-dir . && \
    cd - && \
    rm -r ./CLIP

ARG NB_USER=jovyan

ARG NB_UID=1000

ENV USER ${NB_USER}

ENV NB_UID ${NB_UID}

ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY ./image_search.ipynb ./utils.py ./start ${HOME}/

USER root

RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}

USER ${NB_USER}