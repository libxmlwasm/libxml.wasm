# libxml_wasm

```bash
docker build --load -t lxml:latest --progress=plain .
docker run --name lxml --rm -d -v "$(pwd)/cache:/tmp/cache" -v "$(pwd)/scripts:/scripts" -v "$(pwd)/.:/home/emscripten/src" -u emscripten -e TERM=xterm-256color -e PREFIX=/home/emscripten/src/prefix lxml:latest /bin/bash -c "while :; do sleep 1; done"
# docker exec -it lxml /bin/bash
docker exec -it lxml /scripts/vendor.sh
docker exec -it -w /home/emscripten/src lxml /scripts/wasm.sh
docker kill lxml

# Building
docker run --name lxml --rm -d -v "$(pwd)/cache:/tmp/cache" -v "$(pwd)/scripts:/scripts" -v "$(pwd)/.:/home/emscripten/src" -u emscripten -e PREFIX=/home/emscripten/src/prefix lxml:latest /scripts/ci.sh
# ↑No
```
