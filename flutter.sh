#!/bin/bash -e

IMG=git.gmoker.com/icing/flutter:main

docker volume create --ignore flutter_cache
docker volume create --ignore flutter_cache1
set -x
docker run -it --rm -v "flutter_cache:/root/" \
    -v "flutter_cache1:/opt/android-sdk/" \
    -v "/dev/bus/usb/:/dev/bus/usb/" -v "$PWD:/app/" "$IMG" "$@"
