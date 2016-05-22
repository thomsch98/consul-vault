#!/usr/bin/env sh

. vault.sh

RES=$(vault_get sys/init | jq '.initialized')
if [ "$RES" = "false" ] ; then
	vault_put sys/init "{\"secret_shares\":1, \"secret_threshold\":1}" > /data/init.json
    X_VAULT_TOKEN=$(jq -r '.root_token' /data/init.json)
fi

cat /data/init.json

RES=$(vault_get sys/seal-status | jq '.sealed')
if [ "$RES" = "true" ] ; then
    KEY=$(jq '.keys[0]' /data/init.json)
	vault_put sys/unseal "{\"key\":${KEY}}"
fi

vault_get sys/mounts | jq '.[]'

vault_post sys/mounts/consul "{\"type\":\"consul\", \"description\":\"consul secret backend\"}"
