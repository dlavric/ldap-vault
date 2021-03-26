#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which docker 2>/dev/null || {
  apt-get update
  apt-get install -y docker.io
}

which ldapmodify 2>/dev/null || {
  apt-get update
  apt-get install -y ldapscripts
}
