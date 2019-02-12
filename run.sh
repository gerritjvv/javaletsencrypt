#!/usr/bin/env bash


if [ -z "$DOMAIN" ]; then
 echo "DOMAIN is not defined"
 exit -1
fi


if [ -z "$EMAIL" ]; then
	echo "EMAIL not defined"
	exit -1
fi

cert_digital_ocean () {


if [ -z "DIGITALOCEAN_ACCESS_TOKEN" ]; then
 echo "DIGITALOCEAN_ACCESS_TOKEN is not defined"
 exit -1
fi

cat > ~/.digitalocean.ini <<EOF
dns_digitalocean_token = $DIGITALOCEAN_ACCESS_TOKEN
EOF

chmod 600 ~/.digitalocean.ini

certbot certonly \
  --dns-digitalocean \
  --dns-digitalocean-credentials ~/.digitalocean.ini \
  --dns-digitalocean-propagation-seconds 60 \
  --agree-tos \
  --email $EMAIL \
  --non-interactive \
  -d $DOMAIN -d www.${DOMAIN} certonly

}

cert () {

certbot certonly \
  --dns-digitalocean \
  --dns-digitalocean-credentials ~/.secrets/certbot/digitalocean.ini \
  --dns-digitalocean-propagation-seconds 60 \
  --agree-tos \
  --email $EMAIL \
  --non-interactive \
  -d $DOMAIN -d www.${DOMAIN}


}

CMD "$1"
shift

case $CMD in 
	digitalocean )
      cert_digital_ocean
      ;;
    * )
	  cert
	  ;;
esac
