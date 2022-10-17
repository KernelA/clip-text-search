FROM ghcr.io/kernela/clip-text-search:master-6fe2573dfa62f602a0b3def91e593e3b00897ddb

ARG NB_USER=jovyan

ARG NB_UID=1000

ENV USER ${NB_USER}

ENV NB_UID ${NB_UID}

ENV HOME /home/${NB_USER}

USER root

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}

USER ${NB_USER}

COPY --chown=${NB_UID} ./image_search.ipynb ./utils.py ./
