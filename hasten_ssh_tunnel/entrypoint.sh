#!/bin/bash -e

if [ -z ${LOCAL_PORT+x} ]; then
  echo "'LOCAL_PORT' var must be set - a locally bound port."
  exit 1
fi

if [ -z ${FORWARD_TO+x} ]; then
  echo "'FORWARD_TO' var must be set - to 'host:port'."
  exit 1
fi

if [ -z ${CONNECTION_STRING+x} ]; then
  echo "'CONNECTION_STRING' var must be set - to 'user@ssh_host'."
  exit 1
fi

if [ -n ${PRIVKEY_BASE64+x} ]; then
  echo ${PRIVKEY_BASE64} | base64 -d > /.ssh/id_rsa
  chmod 600 /.ssh/id_rsa
fi

if [ ! -f /.ssh/id_rsa ]; then
  echo "'/.ssh/id_rsa' file must exist or 'PRIVKEY_BASE64' var must be set ."
  exit 1
fi

if [ -z ${SSH_CMD+x} ]; then
  export SSH_CMD="sleep 30"
fi

exec ssh \
      -i /.ssh/id_rsa \
      -o "StrictHostKeyChecking=no" \
      -L 0.0.0.0:${LOCAL_PORT}:${FORWARD_TO} ${CONNECTION_STRING} \
      ${SSH_CMD}
