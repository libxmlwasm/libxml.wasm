FROM emscripten/emsdk:3.1.53

RUN apt-get update
RUN apt-get install -qqq -y --no-install-recommends autopoint po4a ninja-build pkg-config
USER emscripten
WORKDIR /home/emscripten
