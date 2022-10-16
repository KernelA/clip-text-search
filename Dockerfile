FROM ghcr.io/kernela/clip-text-search:master-029994829121305d0c8728feb23ebd115266387b

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
