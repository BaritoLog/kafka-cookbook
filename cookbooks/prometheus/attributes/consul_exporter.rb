#
# Cookbook:: prometheus
# Attributes:: consul_exporter
#
# Copyright:: 2018, BaritoLog.

# Consul Exporter directory
default["consul_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/consul_exporter"
default["consul_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["consul_exporter"]["binary"] = "#{node["consul_exporter"]["dir"]}/consul_exporter"

# Consul Exporter version
default["consul_exporter"]["version"] = "0.5.0"
default["consul_exporter"]["checksum"] = "4592b3e0e1b1f1ed18bd2a95a19016feb081bb0eb304d6e48cbbae030aee7805"
default["consul_exporter"]["binary_url"] = "https://github.com/prometheus/consul_exporter/releases/download/v#{node["consul_exporter"]["version"]}/consul_exporter-#{node["consul_exporter"]["version"]}.linux-amd64.tar.gz"

# Consul Exporter flags
default["consul_exporter"]["flags"]["log.level"] = "info"
default["consul_exporter"]["flags"]["consul.timeout"]="25s"
