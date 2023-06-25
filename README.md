# libxml_wasm

```bash
docker build --load -t lxml:latest --progress=plain .
docker run --name lxml --rm -d -v "$(pwd)/scripts:/scripts" -v "$(pwd)/.:/home/emscripten/src" -u emscripten -e TERM=xterm-256color lxml:latest /bin/bash -c "while :; do sleep 1; done"
docker exec -it lxml /bin/bash
docker exec -it -e PREFIX=/home/emscripten/src/prefix lxml /scripts/vendor/00-libxml2.sh
docker exec -it -w /home/emscripten/src lxml /scripts/wasm.sh
docker kill lxml
```
