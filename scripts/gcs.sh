#!/usr/bin/env bash

set -ex

bucket=$1
project=$2
service_account_key=$3

if [[ -n "$project" ]]; then
  bucket_opts="-p $project"
fi

if [[ -n "$service_account_key" ]]; then
  gcloud auth activate-service-account --key-file $service_account_key
 fi

gsutil ls gs://$bucket || gsutil mb $bucket_opts gs://$bucket
gsutil versioning set on gs://$bucket
