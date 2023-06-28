FROM emscripten/emsdk:3.1.42

RUN apt update
RUN apt install -qqq -y --no-install-recommends autopoint po4a ninja-build
# RUN echo emscripten ALL=NOPASSWD: ALL > /etc/sudoers.d/emscripten && \
#   chmod 0440 /etc/sudoers.d/emscripten && \
#   visudo -c

# Install ninja
# RUN \
#   curl -kLo /tmp/ninja-linux.zip https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip && \
#   unzip -d /usr/local/bin /tmp/ninja-linux.zip && \
#   rm /tmp/ninja-linux.zip

USER emscripten
# COPY --chown=emscripten . /home/emscripten/src
# VOLUME /home/emscripten/src
WORKDIR /home/emscripten
# ARG BASEDIR=/home/emscripten/src
# ARG PREFIX=${BASEDIR}/prefix
# ARG TMPDIR=${BASEDIR}/cache

# RUN embuilder build icu
# RUN --mount=source=scripts/vendor/00-zlib.sh,target=/tmp/scripts/00-zlib.sh,readonly \
#   bash /tmp/scripts/00-zlib.sh
# RUN src/scripts/vendor/10-libiconv.sh
# RUN src/scripts/vendor/20-libxml2.sh
# RUN src/scripts/wasm.sh
