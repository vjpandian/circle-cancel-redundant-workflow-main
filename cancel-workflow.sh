echo -e "The current commit is $CIRCLE_SHA1\n"
CIRCLE_SHA1="$CIRCLE_SHA1"
echo -e "Getting pipeline ids for $CIRCLE_SHA1 and writing it to pipelines.json\n\n\n"
curl https://circleci.com/api/v2/project/github/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pipeline?branch=main -H "Circle-Token: $CIRCLE_TOKEN" | jq -r '.items[]|select(.vcs.revision == env.CIRCLE_SHA1).id' > pipelines.json
echo -e "EOF\n\n"
pipeline_count=$(wc -l < pipelines.json)
echo -e "There are ${pipeline_count} pipeline(s) found so far\n"
if [ "${pipeline_count}" -ge 2 ]; 
then
    echo "Found a pipeline that already ran for the same SHA"
    echo "-----"
    cat pipelines.json
    echo "-----"
    echo -e "Since a pipeline has already run for this $CIRCLE_SHA1, cancelling current workflow\n\n"
    curl --request POST --url https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/cancel -H "Circle-Token: $CIRCLE_TOKEN" 
    sleep 5
    exit 1
else
     echo -e "Found only one pipeline for this commit..will not cancel since the metadata will match the current workflow...\n\n"
     pipeline_id=$(curl https://circleci.com/api/v2/project/github/vjpandian/solid-goggles/pipeline?branch=main -H "Circle-Token: $CIRCLE_TOKEN" | jq -r '.items[]|select(.vcs.revision == env.CIRCLE_SHA1).id')
     echo $pipeline_id
     echo -e "\n\nReturning pipeline metadata for the one pipeline found...it should match the current pipeline and workflow\n\n"
     curl https://circleci.com/api/v2/pipeline/$pipeline_id -H "Circle-Token: $CIRCLE_TOKEN"
fi
