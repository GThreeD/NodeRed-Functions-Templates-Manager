# Quick start

## Requirements
- Docker
- kubectl
- Existing PVC
- Running Node-RED

## Required environment variables

IMAGE=registry.local/nodered-functions-manager:123
NAMESPACE=automation
PVC_NAME=my-nodered-pvc
DATA_PATH=/data
FLOWS_FILE=/data/flows.json
SERVER_AT=http://node-red:1880

Optional:

DEPLOYMENT_NAME=nodered-functions-manager
CONFIGMAP_NAME=nodered-functions-manager-config

## Deploy

./ci/deploy.sh