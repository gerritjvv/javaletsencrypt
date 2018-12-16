#!/usr/bin/env bash
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

set -e
# set -x


LETS_ENCRYPT_DIR=${LETS_ENCRYPT_DIR:-/etc/letsencrypt/live/$DOMAIN}

if [ -z "$DOMAIN" ]; then 
 echo "The DOMAIN environment variable is not defined"
 exit -1
fi

if [ -z "$NAME" ];
then
 echo "The NAME environment variable is not defined"
 exit -1
fi

if [ -z "$KS_PASSWORD" ];
then
 echo "The KS_PASSWORD environment variable is not defined"
 exit -1
fi

if [ -z "$KS_PATH" ];
then
 echo "The KS_PATH environment variable is not defined"
 exit -1
fi

if [ -z "$SECRET_NAMESPACES" ];
then
 echo "SECRET_NAMESPACES must be defined"
 exit -1
fi 

(
  cd "$LETS_ENCRYPT_DIR"
  openssl pkcs12 -export -in fullchain.pem -inkey privkey.pem -out $KS_PATH -name $NAME -CAfile chain.pem -caname root -password env:KS_PASSWORD
  chmod a+r $KS_PATH

  #CREATE kubernetes secrets
 SECRET_NAME="certbot"

 for SECRET_NAMESPACE in $SECRET_NAMESPACES; do
 echo "Generating kubernetes secret ${SECRET_NAME} (namespace ${SECRET_NAMESPACE})"
	(cat > "${SECRET_NAMESPACE}-${SECRET_NAME}.yml" <<EOF
	apiVersion: v1
	kind: Secret
	metadata:
	  name: "${SECRET_NAME}"
	  namespace: "${SECRET_NAMESPACE}"
	type: Opaque
	data:
	  cert.pem: "$(cat /etc/letsencrypt/live/${DOMAIN}/cert.pem | base64 --wrap=0)"
	  chain.pem: "$(cat /etc/letsencrypt/live/${DOMAIN}/chain.pem | base64 --wrap=0)"
	  fullchain.pem: "$(cat /etc/letsencrypt/live/${DOMAIN}/fullchain.pem | base64 --wrap=0)"
	  privkey.pem: "$(cat /etc/letsencrypt/live/${DOMAIN}/privkey.pem | base64 --wrap=0)"
	  keystore.p12 "$(cat ${KS_PATH} | base64 --wrap=0)"
EOF
	) 
	echo kubectl apply -f "${SECRET_NAMESPACE}-${SECRET_NAME}.yml"

 done

)


