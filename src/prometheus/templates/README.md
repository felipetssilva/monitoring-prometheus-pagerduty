This is the base config file for prometheus. It contains many place holders that will be replaced
by `prometheus_config_reloader`.
AlertManager's rules and prom target that uses blackbox are declared at api level and `prometheus_config_reloader` is
responsible
for merging them inside current base conf. List of valid placeholders available here :
https://gitlab.eulerhermes.com/deployment/datahub/devops/prometheus/prometheus_config_reloader/-/blob/master/README.md#template-placeholders