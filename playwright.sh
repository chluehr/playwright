#!/bin/sh

S3_URL=s3://$AWS_S3_BUCKET/project/$PROJECT_ID

echo "DOWNLOAD baseline ..."
aws s3 cp --acl public-read --metadata-directive REPLACE --recursive $S3_URL/baseline playwright/snapshots

echo "RUN TESTS ..."
yarn playwright test
TEST_STATUS=$?

echo "UPLOAD results ..."
aws s3 cp --acl public-read --metadata-directive REPLACE --recursive playwright/report $S3_URL/$BUILD_ID/

if [ $TEST_STATUS -ne 0 ]; then

  echo 
  echo "==> ERROR: CHANGES DETECTED! <=="
  echo

  echo "UPDATE baseline ..."
  yarn playwright test --update-snapshots

  echo "UPLOAD baseline ..."
  aws s3 cp --acl public-read --metadata-directive REPLACE --recursive playwright/snapshots $S3_URL/baseline/
  echo -n "FAILURE: "
else
 echo
 echo -n "SUCCESS: "
fi

echo "Report: https://s3.$AWS_DEFAULT_REGION.amazonaws.com/$AWS_S3_BUCKET/project/$PROJECT_ID/$BUILD_ID/index.html"

# Return the test status
exit $TEST_STATUS

