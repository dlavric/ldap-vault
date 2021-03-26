#!/bin/bash

docker rm ldap --force
docker rm vault --force
docker network rm ldap