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

# Install nvm
USER emscripten
RUN --mount=type=bind,source=.nvmrc,target=./.nvmrc \
  --mount=type=bind,source=package.json,target=./package.json \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
  NVM_DIR="$HOME/.nvm" \
  . ~/.nvm/nvm.sh ; \
  nvm install && \
  nvm use && \
  node -v && \
  corepack prepare && \
  SHELL=bash corepack pnpm setup
SHELL ["/bin/bash", "-c"]
RUN NVM_DIR="$HOME/.nvm" . ~/.nvm/nvm.sh; \
. $HOME/.bashrc && \
source $HOME/.bashrc && \
  PNPM_HOME="$HOME/.local/share/pnpm" \
  PATH="$PNPM_HOME:$PATH" \
  corepack pnpm add -g typescript
