#!/bin/sh
set -e

# -------------------------------------------------------------------
# Required environment variables
# -------------------------------------------------------------------

: "${IMAGE:?IMAGE is not set}"
: "${NAMESPACE:?NAMESPACE is not set}"
: "${PVC_NAME:?PVC_NAME is not set}"
: "${DATA_PATH:?DATA_PATH is not set}"
: "${FLOWS_FILE:?FLOWS_FILE is not set}"
: "${SERVER_AT:?SERVER_AT is not set}"

# Optional
DEPLOYMENT_NAME=${DEPLOYMENT_NAME:-nodered-functions-manager}
CONFIGMAP_NAME=${CONFIGMAP_NAME:-nodered-functions-manager-config}

echo "Deploying ${DEPLOYMENT_NAME}"
echo "Namespace: ${NAMESPACE}"
echo "Image: ${IMAGE}"
echo "PVC: ${PVC_NAME}"
echo "ConfigMap: ${CONFIGMAP_NAME}"

# -------------------------------------------------------------------
# Create or update ConfigMap
# -------------------------------------------------------------------

kubectl -n "${NAMESPACE}" create configmap "${CONFIGMAP_NAME}" \
  --from-literal=FLOWS_FILE="${FLOWS_FILE}" \
  --from-literal=SERVER_AT="${SERVER_AT}" \
  --dry-run=client -o yaml | kubectl apply -f -

# -------------------------------------------------------------------
# Deploy application
# -------------------------------------------------------------------

export IMAGE NAMESPACE PVC_NAME DATA_PATH CONFIGMAP_NAME DEPLOYMENT_NAME

envsubst < k8s/base/deployment.yaml.template | kubectl apply -f -
