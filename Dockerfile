FROM emscripten/emsdk:3.1.42
ARG UID=1001
ARG GID=1001
ARG USERNAME=runner

RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && \
  apt install -qqq -y --no-install-recommends autopoint po4a ninja-build

RUN groupadd -g ${GID:-1001} ${USERNAME}
RUN useradd -u ${UID:-1001} -g ${USERNAME} -m ${USERNAME}
RUN echo emscripten ALL=NOPASSWD: ALL > /etc/sudoers.d/${USERNAME} && \
  chmod 0440 /etc/sudoers.d/${USERNAME} && \
  visudo -c

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV UID ${UID}
ENV GID ${GID}
ENV USERNAME ${USERNAME}
