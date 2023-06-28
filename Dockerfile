FROM emscripten/emsdk:3.1.42

RUN apt update
RUN apt install -qqq -y --no-install-recommends autopoint po4a ninja-build
RUN echo emscripten ALL=NOPASSWD: ALL > /etc/sudoers.d/emscripten && \
  chmod 0440 /etc/sudoers.d/emscripten && \
  visudo -c

USER emscripten
WORKDIR /home/emscripten
