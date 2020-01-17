#!/usr/bin/env bash
echo "This script does the inital checkout of the Automic Demo scripts and enables the necessary GCP API's. The Cloud Platform project must be set in the gcloud environment before executing this script."

if [ -z $DEVSHELL_PROJECT_ID ]
then
  echo "Project ID not set."
  exit
fi

echo "Enabling service API's. . ."
gcloud services enable dns.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable deploymentmanager.googleapis.com

#gcloud compute images list --project demos-esd-automation --filter="name='aemain-cdrive-img-'"
#image_access=$?

#if [ $? -ne 0 ]
#then
#  echo "You do not have permissions to the demo-esd-automation image repository."
#  echo "Send the output of the command 'gcloud projects list' to Marc Carkeek from your Broadcom e-mail address."
#else
#  echo "Access to demo-esd-automation images confirmed."
