# Playwright Docker Image

## Purpose

Visual regression testing. Run your test suite after each
deployment and this tool compares the results against baseline images.
The baseline image are auto-regenerated after each failed 
test run.
The HTML reports on differences and baseline images are stored on S3.

## Mode of operation

Playwright is a headless browser automation tool. 
It runs in Node.js, and comes with a set of 
prebuilt commands for testing web pages.

This opinionated docker container build includes playwright, the aws cli tool for 
uploading images and reports.

The default entry point is a bash script that runs the following commands:
 
* download baseline reference images from S3 (if available)
* run simple screenshotting tests and compare images against the baseline
* upload new baseline images to S3 on failure
* upload HTML reports to S3

## Usage

Put your playwright tests in the `tests-e2e` directory, then
run the tool.

Example:
```bash
docker run -it --rm  \
	-e AWS_ACCESS_KEY_ID=MY_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY=MY_SECRET_ACCESS_KEY \
	-e AWS_DEFAULT_REGION='eu-central-1' \
	-e AWS_S3_BUCKET='MY.S3.BUCKET.NAME' \
	-e PROJECT_ID='MY_PROJECT_NAME' \
	-e PROJECT_URL='https://example.com' \
	-e BUILD_ID=$BUILD_ID \
	-v $PWD/tests-e2e:/app/playwright/tests-e2e \
	playwright
```

The ```BUILD_ID``` is used as the revision number for the screenshots.
Use something like:
* ```BITBUCKET_BUILD_NUMBER``` (incrementing)
* ```BITBUCKET_COMMIT``` (hash)
  ... on your CI system or a simple timestamp:
```
export BUILD_ID=$(date +%s)
```

If you need to customize the playwright options, mount
a modified playwright config file or use this docker 
image as base image.

## Writing tests

Tests are ordinary playwright tests.

Example ```tests-e2e/screenshots.spec.ts```:
```typescript
import { test, expect } from '@playwright/test';

const testCases = [
  { name: 'Example Demo Page', url: '/demo.html' },
  // add more here
];

testCases.forEach(({ name, url }) => {
  test('Page: ' + name, async ({ page }) => {
    await page.goto(url);
    await expect(page).toHaveScreenshot({fullPage: true});
  });
});
```

See https://www.lambdatest.com/learning-hub/playwright-visual-regression-testing
and the official documentation for Playwright.

## License

The scripts are released under MIT license.
See `LICENSE` file.

## Todo

* add instructions for S3 bucket setup (and bucket policy), add notes to
** choose low storage class
** set to auto-purge (max 90 days?)
** security considerations
* add environment and/or user? (for local testing?)

