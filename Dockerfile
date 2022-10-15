FROM continuumio/miniconda3:4.12.0

RUN apt update && \
    apt install unzip -y

RUN conda install -n base -y -c conda-forge mamba && \
    mamba clean -ya

WORKDIR /home

COPY ./environment.yaml ./

RUN mamba env update -n base --file ./environment.yaml && \
    mamba clean -ya 

ARG NB_USER=jovyan

ARG NB_UID=1000

ENV USER ${NB_USER}

ENV NB_UID ${NB_UID}

ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root

RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}

USER ${NB_USER}

RUN python -c "import clip; clip.load('ViT-B/32')"

COPY --chown=${NB_UID} ./image_search.ipynb ./utils.py ./