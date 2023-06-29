FROM emscripten/emsdk:3.1.53

RUN apt-get update
RUN apt-get install -qqq -y --no-install-recommends autopoint po4a ninja-build pkg-config
RUN echo "emscripten ALL=NOPASSWD: ALL" >> /etc/sudoers.d/emscripten && \
  chmod 0440 /etc/sudoers.d/emscripten && \
  usermod -aG sudo emscripten && \
  visudo -c

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV UID ${UID}
ENV GID ${GID}
ENV USERNAME ${USERNAME}
RUN echo [ENV] UID: ${UID}, GID: ${GID}, USERNAME: ${USERNAME}
