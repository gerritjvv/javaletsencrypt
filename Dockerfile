FROM ubuntu


# Install certbot, and kubectl
RUN \
  apt-get update && \
  apt-get install ---yes git wget python3-setuptools && \
  apt-get clean && \
  easy_install pip && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  git clone https://github.com/certbot/certbot /opt/certbot && \
  ln -s /opt/certbot/certbot-auto /usr/local/bin/certbot-auto && \
  certbot-auto; exit 0 && \
  cd certbot/certbot-dns-digitalocean/ && \
  python3 setup.py install && \
  cd - && \
  wget https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/local/bin && \
  certbot-auto --non-interactive --install-only

# required to make digital ocean plugin install work
RUN apt-get install -y curl && \
    cd /tmp && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    pip3 install certbot-dns-digitalocean

WORKDIR /opt/certbot

COPY bin/convertkeystore.sh /opt/certbot/convertkeystore.sh
COPY bin/renewcerts.sh /opt/certbot/renewcerts.sh
COPY run.sh /opt/certbot/run.sh

CMD ["/opt/certbot/renewcerts.sh"]