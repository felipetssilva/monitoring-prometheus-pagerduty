# new-prometheus-infra

This is the monitoring stack used at Datahub. It is composed of the following services.

- [Prometheus](https://prometheus.io/) server pulling, storing and exposing metrics 
- [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) for alert management based on metrics 
- [Pushgateway](https://prometheus.io/docs/practices/pushing/) endpoint allowing pushing metrics to prometheus 
- A few exporters :
    - [Cloudwatch exporter](https://gitlab.eulerhermes.com/deployment/datahub/devops/prometheus/cloudwatch-exporter) Collects Cloudwatch metrics and expose them in prometheus format
    - [Snowflake exporter](https://gitlab.eulerhermes.com/deployment/datahub/devops/snowflake-prometheus-exporter) Collects Snowflake metrics and expose them in prometheus format
    - [Blackbox exporter](https://github.com/prometheus/blackbox_exporter) Collects probe metrics and expose them in prometheus format

## Deployment

This stack need a first apply on security groups because of how terraform manages for_each and locals. Examples are for dev environment.

```sh
# any other apply
terraform apply
# For EFS to be attachable to ECS service you need to first run lambda that generated configuration
export ENVIRONMENT=dev
aws lambda invoke --function-name lbd-${ENVIRONMENT}-datahub-monitoring-blackbox test
aws lambda invoke --function-name lbd-${ENVIRONMENT}-datahub-monitoring-cloudwatch test
aws lambda invoke --function-name lbd-${ENVIRONMENT}-datahub-monitoring-prometheus test
```

This will deploy a new monitoring cluster called `ecs-dev-datahub-monitoring`. URLs are following the pattern `https://datahub-monitoring-<service_name>.<env>.eulerhermes.io`

## Destroy

:warning: change <environment> by the environment you want to target

```sh
## Empty all buckets
cd src/scripts/empty_buckets
python -m venv venv
. venv/bin/activate
python -m pip install -r requirements.txt
python empty-buckets.py --environment <environment>
deactivate

## destroys with terraform
cd live/<environment>
# this may take around 40 min as lambda security group take around 25min to destroys
terraform destroy
# NOTE: It may fail saying that you have object in access log and prometheus-reloader buckets
# please delete objects manually (CLI or Console) and re-run terraform destroy until stack is fully destroyed
```

## Configuration

See [docs/README.md#configuration](docs/old/README.md#configuration)


## Next Steps

- Do not use config_reloader lambda to update blackbox configuration but instead integrate configuration into docker image like it is done is alertmanager (or harmonize alertmanager configuration with this repo)
- write an ADR about why we now use lambda based config-reloader instead of docker sidecar config-reloader
# monitoring-prometheus-pagerduty
