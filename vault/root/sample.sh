#!/usr/bin/env sh

. vault.sh

vault_post secret/foo '{"value":"baz"}' 'application/json'

vault_get secret/foo | jq '.data.value'

