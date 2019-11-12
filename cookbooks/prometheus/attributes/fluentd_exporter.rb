#
# Cookbook:: prometheus
# Attributes:: fluentd_exporter
#
# Copyright:: 2018, BaritoLog.

# Fluentd Exporter directory
default["fluentd_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/fluentd_exporter"
default["fluentd_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["fluentd_exporter"]["binary"] = "#{node["fluentd_exporter"]["dir"]}/fluentd_exporter"

# Fluentd Exporter version
default["fluentd_exporter"]["version"] = "0.2.0"
default["fluentd_exporter"]["checksum"] = "f5cb30f434ea5fd01b4c5362307e28411bde621a4f59c6b3abb496eac3fa9407"
default["fluentd_exporter"]["binary_url"] = "https://github.com/V3ckt0r/fluentd_exporter/releases/download/#{node["fluentd_exporter"]["version"]}/fluentd_exporter-#{node["fluentd_exporter"]["version"]}.linux-amd64.tgz"

# Fluentd Exporter flags
default["fluentd_exporter"]["flags"]["-no-insecure"] = ""
