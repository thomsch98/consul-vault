#!/bin/sh

for kv in $(env) ; do
    key=${kv%%=*}
    val=${kv##*=}
    if [ -n "$(echo $key | grep '^DM_.*')" ] ; then
        consul="$consul\n\tserver $key $val:18500 maxconn 32"
        vault="$vault\n\tserver $key $val:18200 maxconn 32"
    fi
done        

cat <<EOT > /usr/local/etc/haproxy/haproxy.cfg
# Simple configuration for an HTTP proxy listening on port 80 on all
# interfaces and forwarding requests to a single backend "servers" with a
# single server "server1" listening on 127.0.0.1:8000
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
    
listen stats *:1936
    mode            http
    log             global

    maxconn 10

    clitimeout      100s
    srvtimeout      100s
    contimeout      100s
    timeout queue   100s

    stats enable
    stats hide-version
    stats refresh 30s
    stats show-node
    stats auth stats:stats
    stats uri  /
        
frontend consul-http-in
    bind *:8500
    default_backend consul-servers

backend consul consul-servers
EOT
echo $consul >> /usr/local/etc/haproxy/haproxy.cfg 

cat <<EOT >> /usr/local/etc/haproxy/haproxy.cfg
frontend vault-http-in
    bind *:8200
    default_backend vault-servers

backend vault-servers
EOT
echo $vault >> /usr/local/etc/haproxy/haproxy.cfg 

exec "$@"
