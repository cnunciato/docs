#!/bin/bash

set -o errexit -o pipefail

# This script prepares a new S3 bucket for deployment. It runs before `pulumi
# up` (or `pulumi preview` for pull requests) and is responsible for producing
# the JSON manifest (origin-bucket-metatada.json) required by the Pulumi
# operation.

# Log in using the Deployments-issued access token.
pulumi login

# Open the environment configured for this stack.
echo "Opening the '${PULUMI_ESC_ENVIRONMENT}' environment..."
eval $(pulumi env open "${PULUMI_ESC_ENVIRONMENT}" --format shell)

# Select the current stack.
echo "Selecting the '${PULUMI_STACK_NAME}' stack..."
pulumi -C infrastructure stack select "${PULUMI_STACK_NAME}"

# Build the site.
./scripts/build-site.sh

# Create a new bucket and push files to it.
./scripts/sync-and-test-bucket.sh

# Generate a search index.
./scripts/generate-search-index.sh

# Make S3 redirects.
./scripts/make-s3-redirects.sh
