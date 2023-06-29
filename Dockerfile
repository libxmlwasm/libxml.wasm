FROM emscripten/emsdk:3.1.42
ARG UID
ARG GID
ARG USERNAME

ENV UID ${UID}
ENV GID ${GID}
ENV USERNAME ${USERNAME}
RUN echo UID: ${UID}, GID: ${GID}, USERNAME: ${USERNAME}

RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && \
  apt install -qqq -y --no-install-recommends autopoint po4a ninja-build

RUN groupadd -g ${GID} ${USERNAME}
RUN useradd -u ${UID} -g ${USERNAME} -m ${USERNAME}
RUN echo emscripten ALL=NOPASSWD: ALL > /etc/sudoers.d/${USERNAME} && \
  chmod 0440 /etc/sudoers.d/${USERNAME} && \
  visudo -c

USER ${USERNAME}
WORKDIR /home/${USERNAME}
