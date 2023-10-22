#!/bin/bash

set -o errexit -o pipefail

# What was copied into the pre-run setup:
# pulumi login && eval $(pulumi env open $PULUMI_ESC_ENVIRONMENT --format shell) && pulumi stack select $PULUMI_STACK_NAME && cd .. &&  make ensure build && ./scripts/sync-and-test-bucket.sh update

# Log in using the Deployment-issued access token.
pulumi login

# Open the environment configured for this stack.
echo "Opening the '${PULUMI_ESC_ENVIRONMENT}' environment..."
eval $(pulumi env open "${PULUMI_ESC_ENVIRONMENT}" --format shell)

# Select the current stack.
echo "Selecting the '${PULUMI_STACK_NAME}' stack..."
pulumi -C infrastructure stack select "${PULUMI_STACK_NAME}"

echo "Installing dependencies..."
./scripts/clean.sh
./scripts/ensure.sh

echo "Building the site..."
./scripts/build-site.sh

echo "Syncing and testing..."
./scripts/sync-and-test-bucket.sh update

echo "Generating the search index..."
./scripts/generate-search-index.sh

echo "Making S3 redirects..."
./scripts/make-s3-redirects.sh

# A few questions:

# * Why do we check out the repo on destroy?
# * Why do we run the setup on destroy?
