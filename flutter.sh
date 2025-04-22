#!/bin/bash -e

IMG=git.gmoker.com/icing/flutter:main

docker volume create --ignore flutter_cache
set -x
docker run -it --network host --rm -v "flutter_cache:/root/" -v "$PWD:/app/" --entrypoint flutter "$IMG" --no-version-check "$@"
