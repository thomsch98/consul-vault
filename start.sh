#!/bin/bash

if [ "$1" = "" ] ; then
    echo "we need at least one argument to forward to docker-compose :-)"
    exit 1
fi

DIR=$(dirname $0)
NAME=$(basename $0 .start.sh)
if [ "$NAME" = "start.sh" ] ; then
    echo "Rename script or use symbolic link"
    exit 2
fi

DOTENV=$DIR/.$NAME.env

# If available, read environment variables from file .env
[ -f "$DOTENV" ] && export $(cat $DOTENV | grep -v ^# | xargs)

docker-compose $@
