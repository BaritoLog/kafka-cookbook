#
# Cookbook:: prometheus
# Attributes:: default
#
# Copyright:: 2018, BaritoLog.

# Prometheus user
default["prometheus"]["user"] = "prometheus"
default["prometheus"]["group"] = "prometheus"

# Prometheus version
default["prometheus"]["version"] = "2.11.1"
default["prometheus"]["checksum"] = "50b5f4dfd3f358518c1aaa3bd7df2e90780bdb5292b5c996137c2b1e81102390"
default["prometheus"]["binary_url"] = "https://github.com/prometheus/prometheus/releases/download/v#{node["prometheus"]["version"]}/prometheus-#{node["prometheus"]["version"]}.linux-amd64.tar.gz"

# Prometheus configuration repository
default["prometheus"]["runbooks"]["repo_name"] = "runbooks"
default["prometheus"]["runbooks"]["repo_url"] = "https://gitlab.com/gitlab-com/runbooks"
default["prometheus"]["runbooks"]["branch"] = "master"
default["prometheus"]["runbooks"]["dir"] = ""

# Prometheus directory configuration
default["prometheus"]["dir"] = "/opt/prometheus"
default["prometheus"]["log_dir"] = "/var/log/prometheus"
default["prometheus"]["binary"] = "#{node["prometheus"]["dir"]}/prometheus"
default["prometheus"]["config"]["rules_dir"] = "#{node["prometheus"]["dir"]}/rules"
default["prometheus"]["config"]["alerting_rules_dir"] = "#{node["prometheus"]["dir"]}/alerts"
default["prometheus"]["config"]["recording_rules_dir"] = "#{node["prometheus"]["dir"]}/recordings"
default["prometheus"]["config"]["inventory_dir"] = "#{node["prometheus"]["dir"]}/inventory"

# Prometheus configuration
default["prometheus"]["config"]["scrape_interval"] = "15s"
default["prometheus"]["config"]["scrape_timeout"] = "10s"
default["prometheus"]["config"]["evaluation_interval"] = "15s"
default["prometheus"]["config"]["external_labels"] = {}
default["prometheus"]["config"]["remote_write"] = []
default["prometheus"]["config"]["remote_read"] = []
default["prometheus"]["config"]["scrape_configs"] = []
default["prometheus"]["config"]["alerting"] = []
default["prometheus"]["config"]["rule_files"] = [
  File.join(node["prometheus"]["config"]["rules_dir"], "/*.yml"),
  File.join(node["prometheus"]["config"]["alerting_rules_dir"], "/*.yml"),
  File.join(node["prometheus"]["config"]["recording_rules_dir"], "/*.yml"),
]

# Prometheus flags
default["prometheus"]["flags"]["config.file"] = "#{node["prometheus"]["dir"]}/prometheus.yml"
default["prometheus"]["flags"]["web.enable-admin-api"] = true
default["prometheus"]["flags"]["web.enable-lifecycle"] = true
default["prometheus"]["flags"]["web.external-url"] = "https://#{node["fqdn"]}"
default["prometheus"]["flags"]["storage.tsdb.path"] = "#{node["prometheus"]["dir"]}/data"
default["prometheus"]["flags"]["storage.tsdb.retention"] = "90d"
default["prometheus"]["flags"]["storage.tsdb.max-block-duration"] = "7d"
