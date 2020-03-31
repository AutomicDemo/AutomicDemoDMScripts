gcloud projects add-iam-policy-binding --member serviceAccount:$1-compute@developer.gserviceaccount.com --role roles/compute.imageUser
gcloud projects add-iam-policy-binding --member serviceAccount:$1@cloudservices.gserviceaccount.com --role roles/compute.imageUser
gcloud projects add-iam-policy-binding --member serviceAccount:$2@broadcom.com --role roles/compute.imageUser
