#!/usr/bin/env sh

SCRIPT=$(readlink -f $0)
BASE=$(dirname $SCRIPT)
TMPL_EXT=${TMPL_EXT:-.tmpl}
TMPL=$(find $BASE -name "*$TMPL_EXT")
for IN in $TMPL ; do
    DIR=$(dirname $IN)
    OUT="$DIR/$(basename $IN $TMPL_EXT)"
    echo "$IN -> $OUT"
    rm -f $OUT
set -x
    env envsubst < $IN > $OUT 
set +x
done

echo "Resetting peers.json to empty"
echo "[]" > $BASE/var/consul/raft/peers.json

exec "$@"