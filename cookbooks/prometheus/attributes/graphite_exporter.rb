#
# Cookbook:: prometheus
# Attributes:: graphite_exporter
#
# Copyright:: 2018, BaritoLog.

# Graphite Exporter directory
default["graphite_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/graphite_exporter"
default["graphite_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["graphite_exporter"]["binary"] = "#{node["graphite_exporter"]["dir"]}/graphite_exporter"

# Graphite Exporter version
default["graphite_exporter"]["version"] = "0.6.2"
default["graphite_exporter"]["checksum"] = "9b962bd06406ece4a865ad6947a6e652e48a92a0d77e496a0351c04e9c2c5e9e"
default["graphite_exporter"]["binary_url"] = "https://github.com/prometheus/graphite_exporter/releases/download/v#{node["graphite_exporter"]["version"]}/graphite_exporter-#{node["graphite_exporter"]["version"]}.linux-amd64.tar.gz"

# Graphite Exporter flags
default["graphite_exporter"]["flags"]["log.level"] = "info"
