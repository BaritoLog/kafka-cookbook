#
# Cookbook:: prometheus
# Attributes:: kibana_exporter
#
# Copyright:: 2018, BaritoLog.

# Kibana Exporter directory
default["kibana_exporter"]["kibana_version"] = "6.3.0"
default["kibana_exporter"]["kibana_base_dir"] = "/opt/kibana/#{node["kibana_exporter"]["kibana_version"]}/current/"
default["kibana_exporter"]["url"] = "https://github.com/pjhampton/kibana-prometheus-exporter/releases/download/#{node["kibana_exporter"]["kibana_version"]}/kibana-prometheus-exporter-#{node["kibana_exporter"]["kibana_version"]}.zip"