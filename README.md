# circle-cancel-redundant-workflow-main

A simple CircleCI workflow that checks the API to see if a workflow has already run for a `GitHub SHA`. If yes, it cancels the current workflow.

### CircleCI APIs used

- Get Pipelines for a project - https://circleci.com/docs/api/v2/#operation/listPipelines
- Get a Pipeline by ID - https://circleci.com/docs/api/v2/#operation/getPipelineById
- Cancel a Worfklow by ID - https://circleci.com/docs/api/v2/#operation/cancelWorkflow
