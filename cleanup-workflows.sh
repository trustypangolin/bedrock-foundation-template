#!/bin/bash

OWNER=trustypangolin
REPO=bedrock-foundation-template

# list workflows
# gh api -X GET /repos/$OWNER/$REPO/actions/workflows | jq '.workflows[] | .name,.id'

# Get workflow IDs with status "active"
workflow_ids=($(gh api repos/$OWNER/$REPO/actions/workflows | jq '.workflows[] | select(.["state"] | contains("active")) | .id'))

for workflow_id in "${workflow_ids[@]}"
do
  echo "Listing runs for the workflow ID $workflow_id"
  run_ids=( $(gh api repos/$OWNER/$REPO/actions/workflows/$workflow_id/runs --paginate | jq '.workflow_runs[].id') )
  for run_id in "${run_ids[@]}"
  do
    echo "Deleting Run ID $run_id"
    gh api repos/$OWNER/$REPO/actions/runs/$run_id -X DELETE >/dev/null
  done
done