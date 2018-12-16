# javaletsencrypt

Lets encrypt docker container with kubernetes support specifically for JVM applications.

For JVM applications we need PKCS12 keystores rather than pem files, and in most setups
you require both pems files and keystores, so that the pem files can be used by proxies
like Nginx and the keystores by the JVM applications.


The keystore type is p12


# Requirements

**Envrinonment variables**

| Name | Description |
| LETS_ENCRYPT_DIR | default value ${LETS_ENCRYPT_DIR:-"/etc/letsencrypt/live/$DOMAIN 
| DOMAIN | The domain that you're renewing e.g bla.io 
| NAME | any name you choose 
| KS_PASSWORD | The password used for the keystore 
| KS_PATH | The path + keystore name e.g /etc/keys/keystore.p12 


# Usage


First create a certificate manually by running the `run.sh` command. 
If you're using Kubernetes, launch the certification container with 
```
- name: kubernetes-certbot
        image: gerritjvv/letsencrypt:latest
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "while true; do sleep 30; done;" ]
        imagePullPolicy: Always
```

Then exec into it. The run script supports digital ocean plugins. 

TIP: its easier to just use the cloud provider's dns plugin.

To renew:


Run renewcerts.sh which will call certbot-auto and on renewal call convertkeystore.sh



# References

Taken from https://danielflower.github.io/2017/04/08/Lets-Encrypt-Certs-with-embedded-Jetty.html
