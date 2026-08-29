#!/bin/sh
# Cancel this workflow if a newer run appears on the same branch.
set -eu

project="gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"

while true; do
  newest=$(circleci run list \
    --project "$project" \
    --branch "$CIRCLE_BRANCH" \
    --limit 5 \
    --json --jq '.[0].id')

  if [ "$newest" != "$CIRCLE_PIPELINE_ID" ]; then
    echo "Newer run $newest found; cancelling this workflow $CIRCLE_WORKFLOW_ID"
    circleci workflow cancel "$CIRCLE_WORKFLOW_ID" --force
    exit 0
  fi

  echo "This run is newest; checking again shortly"
  sleep 8
done
