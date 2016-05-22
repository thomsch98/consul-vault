#!/usr/bin/env sh

X_VAULT_TOKEN=

vault_call() {
	CURL_ARGS="-sLX $1"

	[ ! -z "${X_VAULT_TOKEN}" ] && CURL_ARGS="${CURL_ARGS} -H 'X-Vault-Token: ${X_VAULT_TOKEN}'"

	[ ! -z "$3" ] && CURL_ARGS="${CURL_ARGS} -d '$3'"

	[ ! -z "$4" ] && CURL_ARGS="${CURL_ARGS} -H 'Content-Type: $4'"

    eval "curl ${CURL_ARGS} ${VAULT_ADDR}/v1/$2"
}

vault_get() {
    vault_call GET "$1"
}

vault_put() {
    vault_call PUT "$1" "$2"
}

vault_post() {
    vault_call POST "$1" "$2"
}

X_VAULT_TOKEN=$(jq -r '.root_token' /data/init.json)
