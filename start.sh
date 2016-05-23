#!/bin/bash

# If available, read environment variables from file .env
[ -f ".env" ] && export $(cat .env | grep -v ^# | xargs)

BOOTSTRAP=true SERVER=true docker-compose config 

BOOTSTRAP=false SERVER=true docker-compose config