#!/bin/bash
# This script starts a local Docker container with created image.
# Use `-i` to start it in interactive mode (foreground console and auto-remove on exit).
set -e

# Get container host address
HOST_IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n 1`
HOST_NAME="travis"

echo "[I] Starting a Docker container '${PROJECT_NAME}' (version '${PROJECT_VERSION}') from path '${PROJECT_DIR}' and"
echo "    adding parent host '${HOST_NAME}' with IP '${HOST_IP}'."

# Allow to pass -i option to start container in interactive mode
OPTS="-d"
ARGS=""
while getopts "ia:" opt; do
  case "$opt" in
    i)  OPTS="-it --rm"
        ;;
    a)  ARGS=$(eval "echo ${OPTARG}")
  esac
done

docker run -p 4000:4000 -p 4001:4001 -p 4002:4002 \
       --env-file .env \
       ${OPTS} \
       --add-host=$HOST_NAME:$HOST_IP \
       --name ${PROJECT_NAME} \
       "${ARGS}" "${PROJECT_NAME}:${PROJECT_VERSION}"
