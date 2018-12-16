#!/usr/bin/env bash
set -e
set -x

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

certbot-auto renew --post-hook "$dir/convertkeystore.sh"