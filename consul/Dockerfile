FROM alpine:3.3

ENV CONSUL_VER=0.6.4 \
    CONSUL_URL=https://releases.hashicorp.com/consul \
    KEYIDS=51852D87348FFC4C

ADD root /

RUN (apk update || true) && apk add curl ca-certificates gnupg \
    && rm -rf /var/cache/apk/*
    
RUN gpg --keyserver http://pool.sks-keyservers.net:80 --recv-keys ${KEYIDS} \
    && curl -sL ${CONSUL_URL}/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip > consul_${CONSUL_VER}_linux_amd64.zip \
    && curl -sL ${CONSUL_URL}/${CONSUL_VER}/consul_${CONSUL_VER}_SHA256SUMS > app.sha \
    && curl -sL ${CONSUL_URL}/${CONSUL_VER}/consul_${CONSUL_VER}_SHA256SUMS.sig > app.sig \
    && gpg --verify app.sig app.sha \
    && grep linux_amd64 app.sha | sha256sum -sc \
    && unzip *.zip -d /bin \
    && chmod +x /bin/* \
    && rm -f /tmp/* \
    && mkdir -p /var/consul

EXPOSE 8500
VOLUME ["/etc/consul", "/var/consul" ]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/consul", "agent", "-config-dir", "/etc/consul"]
