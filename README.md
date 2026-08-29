# circle-cancel-redundant-workflow-main

When a newer run starts on the same branch, this workflow cancels itself.

Uses the CircleCI CLI (`circleci run list` and `circleci workflow cancel`) in a background loop.
