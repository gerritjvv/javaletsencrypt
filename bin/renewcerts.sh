#!/usr/bin/env bash
set -e

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)


if [ ! -z "DIGITALOCEAN_ACCESS_TOKEN" ]; then

 # ensure that the digital ocean token is always present, incase the certificate was created
 # using it.

 if [ ! -f ~/.digitalocean.ini ]; then 
 cat > ~/.digitalocean.ini <<EOF
  dns_digitalocean_token = $DIGITALOCEAN_ACCESS_TOKEN
EOF

  chmod 600 ~/.digitalocean.ini
 fi 

fi

certbot renew --post-hook "$dir/convertkeystore.sh"