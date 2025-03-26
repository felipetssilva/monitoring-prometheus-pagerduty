#!/bin/bash

ARTIFACT_BUCKET_NAME=yxdzlwvolxmz-apps-artifacts-dwh-bi-datahub
ARTIFACT_ENVIRONMENT="${ENVIRONMENT:-int}"
PROJECT_NAME=prometheus_config_reloader

mkdir -p artifacts/

# Download zipped source code of `prometheus_config_reloader` (used for creating config reloader lambda)
aws s3 cp s3://$ARTIFACT_BUCKET_NAME/datahub/${PROJECT_NAME}/$ARTIFACT_ENVIRONMENT/${PROJECT_NAME}-${ARTIFACT_ENVIRONMENT}.zip artifacts/

# Download zipped promtool artifact (used for creating lambda layer)
aws s3 cp s3://$ARTIFACT_BUCKET_NAME/datahub/${PROJECT_NAME}/$ARTIFACT_ENVIRONMENT/${PROJECT_NAME}-promtool-${ARTIFACT_ENVIRONMENT}.zip artifacts/
