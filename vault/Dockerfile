FROM alpine:3.3

ENV VAULT_VER=0.5.2 \
    VAULT_URL=https://releases.hashicorp.com/vault \
    KEYIDS=51852D87348FFC4C

ADD root /

RUN (apk update || true) && apk add curl ca-certificates gnupg \
    && rm -rf /var/cache/apk/*

RUN gpg --keyserver http://pool.sks-keyservers.net --recv-keys ${KEYIDS} \
    && curl -sL ${VAULT_URL}/${VAULT_VER}/vault_${VAULT_VER}_linux_amd64.zip > vault_${VAULT_VER}_linux_amd64.zip \
    && curl -sL ${VAULT_URL}/${VAULT_VER}/vault_${VAULT_VER}_SHA256SUMS > app.sha \
    && curl -sL ${VAULT_URL}/${VAULT_VER}/vault_${VAULT_VER}_SHA256SUMS.sig > app.sig \
    && gpg --verify app.sig app.sha \
    && grep linux_amd64 app.sha | sha256sum -sc \
    && unzip *.zip -d /bin \
    && chmod +x /bin/* \
    && rm -f /tmp/*

EXPOSE 8200
VOLUME [ "/etc/vault", "/data" ]
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-config", "/etc/vault/vault.json" ]