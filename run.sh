#!/bin/bash

set -eux -o pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 [rosmar|cbs]"
    exit 1
fi

CBS=
case $1 in
    rosmar) ;;
    *)
        CBS=true
        ;;
esac

pkill sync_gateway || true

if [[ -n "${CBS}" ]]; then
    ~/repos/sync_gateway/bin/sync_gateway ./sync_gateway_cbs_basic.json
else
    ~/repos/sync_gateway/bin/sync_gateway ./sync_gateway_rosmar.json
fi
