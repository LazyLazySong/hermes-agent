#!/bin/sh
set -eu

exec /init /opt/hermes/docker/main-wrapper.sh gateway run
