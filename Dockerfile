FROM emscripten/emsdk:3.1.42
ARG UID
ARG GID
ARG USERNAME

ENV UID ${UID}
ENV GID ${GID}
ENV USERNAME ${USERNAME}

RUN apt update
RUN apt install -qqq -y --no-install-recommends autopoint po4a ninja-build

RUN groupadd -g ${GID} ${USERNAME}
RUN useradd -u ${UID} -g ${USERNAME} -m ${USERNAME}
RUN echo emscripten ALL=NOPASSWD: ALL > /etc/sudoers.d/${USERNAME} && \
  chmod 0440 /etc/sudoers.d/${USERNAME} && \
  visudo -c

USER ${USERNAME}
WORKDIR /home/${USERNAME}
