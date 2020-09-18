#
# Cookbook:: prometheus
# Attributes:: default
#
# Copyright:: 2018, BaritoLog.

# Prometheus user
default["prometheus"]["user"] = "prometheus"
default["prometheus"]["group"] = "prometheus"

# Prometheus version
default["prometheus"]["version"] = "2.21.0"
default["prometheus"]["checksum"] = "f1f2eeabbf7822572dce67565dc96ffaa2dd1897dd1d844562552b11123f151a"
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
default["prometheus"]["tls_certs_dir"] = "/opt/prometheus/secrets"
default["prometheus"]["tls_certs"]["enabled"] = false
default["prometheus"]["tls_certs"]["insecure_skip_verify"] = false
default["prometheus"]["tls_certs"]["ca_content"] = ""
default["prometheus"]["tls_certs"]["cert_content"] = ""
default["prometheus"]["tls_certs"]["key_content"] = ""

default["prometheus"]["config"]["scrape_interval"] = "15s"
default["prometheus"]["config"]["scrape_timeout"] = "10s"
default["prometheus"]["config"]["evaluation_interval"] = "15s"
default["prometheus"]["config"]["external_labels"] = {}
default["prometheus"]["config"]["remote_write"] = []
default["prometheus"]["config"]["remote_read"] = []
default["prometheus"]["config"]["scrape_configs"] = []
default["prometheus"]["config"]["alerting"] = {}
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
default["prometheus"]["flags"]["storage.tsdb.retention"] = "30d"
default["prometheus"]["flags"]["storage.tsdb.max-block-duration"] = "2h"
default["prometheus"]["flags"]["storage.tsdb.min-block-duration"] = "2h"
