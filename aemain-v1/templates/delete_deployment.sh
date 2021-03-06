#!/usr/bin/env bash
echo "This script deletes an Automic Demo deployment in your GCP environment."
echo "Enter the number of the deployment you want to delete: (type 'q' to exit)"

dep_list=`gcloud deployment-manager deployments list --simple-list`

select sel_dep in $dep_list;
do
  case $sel_dep in
    q)
      echo "Exiting script."
      break
      ;;
    *)
      preview_check=`gcloud deployment-manager deployments list --simple-list --filter="name='$sel_dep' AND operation.operationType='preview'"`
      if [ $sel_dep != $preview_check ]
      then
        echo "Deleting deployment $sel_dep . . ."
        rset=`gcloud deployment-manager resources list --deployment=$sel_dep --filter="Type:gcp-types/dns-v1:managedZones" --simple-list`
        touch empty-file
        gcloud dns record-sets import -z $rset --delete-all-existing empty-file
        rm empty-file
        gcloud deployment-manager deployments delete $sel_dep
      else
        echo "Cancelling preview $sel_dep . . ."
        gcloud deployment-manager deployments cancel-preview $sel_dep
      fi
      break
      ;;
    esac
  done
