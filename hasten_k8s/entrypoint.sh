#!/bin/bash -e

if [ -z ${CLUSTER+x} ]; then
  echo "'CLUSTER' var must be set."
  exit 1
fi
if [ -z ${CA_CRT_BASE64+x} ]; then
  echo "'CA_CRT_BASE64' var must be set."
  exit 1
fi
if [ -z ${USERNAME+x} ]; then
  echo "'USERNAME' var must be set."
  exit 1
fi
if [ -z ${TOKEN_BASE64+x} ]; then
  echo "'TOKEN_BASE64' var must be set."
  exit 1
fi
if [ -z ${API_HOST+x} ]; then
  export API_HOST="localhost"
fi
if [ -z ${API_PORT+x} ]; then
  export API_PORT="443"
fi

kubectl config set-cluster ${CLUSTER} --server=https://${API_HOST}:${API_PORT}

echo ${CA_CRT_BASE64} | base64 -d > /tmp/ca.crt
kubectl config set-cluster ${CLUSTER} --certificate-authority=/tmp/ca.crt

kubectl config set-context ${CLUSTER} --cluster=${CLUSTER}
if [ -n ${TOKEN_BASE64+x} ]; then
  export TOKEN=$(echo ${TOKEN_BASE64} | base64 -d)
  kubectl config set-credentials ${USERNAME} --token="${TOKEN}"
  kubectl config set-context ${CLUSTER} --user=${USERNAME}
fi
kubectl config use-context ${CLUSTER}

exec "/bin/kubectl" "$@"
