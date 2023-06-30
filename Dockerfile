FROM emscripten/emsdk:3.1.42
ARG HOST_UID
ARG HOST_GID
ARG HOST_USERNAME
ENV HOST_UID ${HOST_UID}
ENV HOST_GID ${HOST_GID}
ENV HOST_USERNAME ${HOST_USERNAME}

RUN echo UID: ${HOST_UID}, GID: ${HOST_GID}, USERNAME: ${HOST_USERNAME}

RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && \
  apt install -qqq -y --no-install-recommends autopoint po4a ninja-build

RUN groupadd -g ${HOST_GID} ${HOST_USERNAME} || echo "group already exists"
RUN useradd -u ${HOST_UID} -g $(id -Gn ${HOST_GID}) -m $(id -un ${HOST_UID}) || echo "user already exists"
RUN echo $(id -un ${HOST_UID}) ALL=NOPASSWD: ALL > /etc/sudoers.d/$(id -un ${HOST_UID}) && \
  chmod 0440 /etc/sudoers.d/$(id -un ${HOST_UID}) && \
  visudo -c

# USER ${HOST_USERNAME}
RUN mkdir /src -p
WORKDIR /src
