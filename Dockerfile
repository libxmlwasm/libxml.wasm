FROM emscripten/emsdk:3.1.42 AS base

RUN apt update
RUN apt install -qqq -y --no-install-recommends autopoint po4a
RUN echo emscripten ALL=NOPASSWD: ALL > /etc/sudoers.d/emscripten && \
  chmod 0440 /etc/sudoers.d/emscripten && \
  visudo -c

# Install ninja
RUN \
  curl -kLo /tmp/ninja-linux.zip https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip && \
  unzip -d /usr/local/bin /tmp/ninja-linux.zip && \
  rm /tmp/ninja-linux.zip

USER emscripten
COPY --chown=emscripten . /home/emscripten/src
WORKDIR /home/emscripten/src
ARG PREFIX=/home/emscripten/src/prefix

RUN embuilder build icu
RUN mkdir -p /tmp/cache
RUN scripts/vendor/00-zlib.sh
RUN scripts/vendor/10-libiconv.sh
RUN scripts/vendor/20-libxml2.sh
RUN scripts/wasm.sh
