FROM ubuntu


# Install certbot, and kubectl
RUN \
  apt-get update && \
  apt-get install ---yes git wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  git clone https://github.com/certbot/certbot /opt/certbot && \
  ln -s /opt/certbot/certbot-auto /usr/local/bin/certbot-auto && \
  certbot-auto; exit 0 && \
  wget https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/local/bin


WORKDIR /opt/certbot

COPY bin/convertkeystore.sh /opt/certbot/convertkeystore.sh
COPY bin/renewcerts.sh /opt/certbot/renewcerts.sh

