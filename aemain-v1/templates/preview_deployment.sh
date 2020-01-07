#!/usr/bin/env bash
if [ $# -eq 0 ]
then
    echo "This script creates an Automic Demo deployment in preview mode."
    echo "Usage: $0 deployment_name"
else
    echo "Creating deployment for Automic Demo in preview mode."
    gcloud deployment-manager deployments create $1 --config aemain-v1-config.yaml --preview
    echo "To continue with deployment type: ./finish_deployment.sh"
    echo "To delete this or other deployments type: ./delete_deployment.sh"
fi
