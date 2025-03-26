#!/usr/bin/env python

import boto3
import click
import logging


logging.basicConfig()
logging.root.setLevel(logging.INFO)


class DatahubBucket:
    product_name = "datahub-monitoring"

    def __init__(
        self, environment: str, short_name: str, is_disaster_recovery: bool = False
    ) -> None:
        self.short_name = short_name
        self.environment = environment
        self.is_disaster_recovery = is_disaster_recovery

    def fullname(self):
        return f"yxdzlwvolxmz-{self.environment}-{self.product_name}-{self.short_name}"


@click.command()
@click.option("--environment", required=True)
def all(environment):
    logging.info("Starting script to empty all bucket of monitoring infrastructure")
    buckets = [
        DatahubBucket(environment, "new-prometheus"),
        DatahubBucket(environment, "access-logs"),
        DatahubBucket(environment, "access-logs-dr", is_disaster_recovery=True),
    ]

    s3 = boto3.resource("s3")
    for bucket in buckets:
        if bucket.is_disaster_recovery:
            s3 = boto3.resource("s3", region_name="eu-west-1")
        else:
            s3 = boto3.resource("s3")
        logging.info("Emptying bucket %s", bucket.fullname())
        bucket = s3.Bucket(bucket.fullname())
        bucket.object_versions.delete()


if __name__ == "__main__":
    all()
