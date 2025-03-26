# Implementation details

## High Availability in Alertmanager

HA can be configured in Alertmanager (AM) to continue receiving Alerts until the last AM node goes down. This is known as cluster mode and can be configured through the startup command of AM.

Alertmanager (AM) can run as a cluster and continue receiving Alerts until the last node goes down (see [HA setup info](https://github.com/prometheus/alertmanager/blob/main/README.md#high-availability)). This mode requires :

- a port dedicated to AM's nodes communication
- a security group allowing in-cluster communication
- a master node
- peer nodes (running `--cluster.peer <master_host>` command argument)

The initial master node is designated as the ECS taks named `alertmanager`. See our custom [alertmanager entrypoint](https://gitlab.eulerhermes.com/deployment/datahub/devops/prometheus/alertmanager/-/blob/master/app/entrypoint.sh) for more info.


Once the cluster is set up, each node can be promoted to master and gossiping (i.e. alerts and silences propagation) will continue even if the initial master node fails.

We have tested some scenarios to better understand the way Alertmanager behaves in cluster mode during outage, these tests can be found in this page : [Alertmanager behaviors during outage](alertmanager-ha-behaviors.md).

The security group used for in-cluster communication allows itself to use alertmanager's cluster post meaning that traffic is allowed to any entity with this SG attached.

Nodes communicate using internal hostnames provided by AWS Service Discovery. We keep ALB purely for external access.

By default, Fargate spreads containers in all reachable availability zones meaning AM service should be resilient to a maximum of two availibilty zone disruption. However, we are not insured that tasks will not be placed in the same AZ as AWS may experience resource shortage and decide to place two tasks in the same AZ. This should be monitored and raise a warning or error alerts when it happens.

## Problems with EFS shared between an ECS Service and a Lambda

Some services config (Prometheus for example) are stored inside an EFS volume that is mounted to the container. As it is commonly done, we first tried to mount EFS's root directory `/` to a dedicated mount point (e.g. `/prometheus-config` but lambdas can't write to EFS's root directory. To solve this we tried to change the mapping to `/prometheus-config` (EFS) --> `/prometheus-config` (container) which lead to another problem : EFS source folder doesn't exist when container starts so so it gets stuck with status=PENDING. Nevertheless, we agreed to keep this mapping but run the lambda first in order to get folder's structure ready before running the container

Currently, both blackbox and prometheus services need to run the lambda first to turn the tasks status into RUNNING.
