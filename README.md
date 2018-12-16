# javaletsencrypt

Lets encrypt docker container with kubernetes support specifically for JVM applications.



The keystore type is p12


# Requirements

*Envrinonment variables*

| LETS_ENCRYPT_DIR | default value ${LETS_ENCRYPT_DIR:-"/etc/letsencrypt/live/$DOMAIN |
| DOMAIN | The domain that you're renewing e.g bla.io |
| NAME | any name you choose |
| KS_PASSWORD | The password used for the keystore |
| KS_PATH | The path + keystore name e.g /etc/keys/keystore.p12 |


# Usage

Run renewcerts.sh which will call certbot-auto and on renewal call convertkeystore.sh



# References

Taken from https://danielflower.github.io/2017/04/08/Lets-Encrypt-Certs-with-embedded-Jetty.html
