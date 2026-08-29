#!/bin/sh
# Cancel other in-progress workflows on this branch. Do not cancel the current one.

ids=$(circleci workflow list \
  --project "gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}" \
  --branch "$CIRCLE_BRANCH" \
  --json --jq '.[] | select(.id != env.CIRCLE_WORKFLOW_ID and .phase != "ended") | .id')

if [ -z "$ids" ]; then
  echo "No redundant workflows to cancel"
  exit 0
fi

echo "$ids" | while IFS= read -r id; do
  echo "Cancelling redundant workflow $id"
  circleci workflow cancel "$id" --force
done
