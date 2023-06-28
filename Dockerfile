FROM emscripten/emsdk:3.1.42

RUN apt update
RUN apt install -qqq -y --no-install-recommends autopoint po4a ninja-build
USER emscripten
WORKDIR /home/emscripten
