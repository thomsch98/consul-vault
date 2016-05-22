#!/usr/bin/env sh

# if command starts with an option, prepend with "vault server"
if [ "${1:0:1}" = '-' ]; then
	set -- /bin/vault server "$@"
fi

# now run command
exec "$@"