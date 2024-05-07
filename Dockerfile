FROM emscripten/emsdk:3.1.59

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && \
  apt-get install -qqq -y --no-install-recommends autopoint po4a ninja-build pkg-config
RUN echo "emscripten ALL=NOPASSWD: ALL" >> /etc/sudoers.d/emscripten && \
  chmod 0440 /etc/sudoers.d/emscripten && \
  usermod -aG sudo emscripten && \
  visudo -c

RUN mkdir /src -p
WORKDIR /src
RUN embuilder build icu
