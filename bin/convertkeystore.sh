#!/usr/bin/env bash
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

set -e
set -x


LETS_ENCRYPT_DIR=${LETS_ENCRYPT_DIR:-"/etc/letsencrypt/live/$DOMAIN"}

if [ -z "$DOMAIN" ];
 echo "The DOMAIN environment variable is not defined"
 exit -1
fi

if [ -z "$NAME" ];
 echo "The NAME environment variable is not defined"
 exit -1
fi

if [ -z "$KS_PASSWORD" ];
 echo "The KS_PASSWORD environment variable is not defined"
 exit -1
fi

if [ -z "$KS_PATH" ];
 echo "The KS_PATH environment variable is not defined"
 exit -1
fi

(
  cd "$LETS_ENCRYPT_DIR"
  openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out $KS_PATH -name $NAME -CAfile chain.pem -caname root -password $PASSWORD
  chmod a+r $KS_PATH
)

