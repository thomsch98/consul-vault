#!/bin/bash -x

if [ "$1" = "--upgrade" ] ; then
  for n in 1 2 3 4 5 ; do
    docker-machine ssh vlpvault0$n "sudo curl -sSL https://get.docker.com/ | sh"
  done

  shift

fi

docker-machine ls

if [ "$1" = "--setup" ] ; then

  for n in 1 2 3 4 5 ; do
    docker-machine ssh vlpvault0$n 'sudo sh -c "grep -v ''10.11.7'' /etc/hosts > /etc/hosts.new"'
    docker-machine ssh vlpvault0$n 'sudo cp /etc/hosts.new /etc/hosts'
  done

  shift
  
fi

if [ "$1" = "--login" ] ; then
  docker login registry.haufe.io
  
  shift
  
fi

if [ "$1" = "--force-clean" ] ; then
  
  for n in 1 2 3 4 5 ; do
    eval $(docker-machine env vlpvault0$n)
    docker-compose stop
    docker-compose rm -fva
  done

  shift

fi

if [ "$1" = "--clean" ] ; then
  
  for n in 1 2 3 4 5 ; do
    eval $(docker-machine env vlpvault0$n)
    docker-compose stop
    docker-compose rm -fa
  done

  shift

fi

if [ "$1" = "--deploy" ] ; then
  
  for n in 1 2 3 4 5 ; do
    eval $(docker-machine env vlpvault0$n)
    docker-compose up -d consul
    docker-compose exec consul sh -c 'grep -v ''10.11.7'' /etc/hosts > /etc/hosts.new'
    docker-compose exec consul sh -c 'for n in 1 2 3 4 5 ; do echo "10.11.7.16$n vlpvault0$n.haufe-ep.de vlpvault0$n" >> /etc/hosts.new ; done'
    docker-compose exec consul sh -c 'cat /etc/hosts.new > /etc/hosts'
    docker-compose exec consul sh -c 'cat /etc/hosts'
    docker-compose ps
  done

  shift

fi

if [ "$1" = "--join" ] ; then
  eval $(docker-machine env vlpvault01)
  docker-compose exec consul sh -c "consul join vlpvault01 vlpvault02 vlpvault03 vlpvault04 vlpvault05"

  shift

fi