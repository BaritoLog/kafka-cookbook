#
# Cookbook:: prometheus
# Attributes:: node_exporter
#
# Copyright:: 2018, BaritoLog.

# Node Exporter directory
default["node_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/node_exporter"
default["node_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["node_exporter"]["binary"] = "#{node["node_exporter"]["dir"]}/node_exporter"

# Node Exporter version
default["node_exporter"]["version"] = "0.18.1"
default["node_exporter"]["checksum"] = "b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424"
default["node_exporter"]["binary_url"] = "https://github.com/prometheus/node_exporter/releases/download/v#{node["node_exporter"]["version"]}/node_exporter-#{node["node_exporter"]["version"]}.linux-amd64.tar.gz"

# Node Exporter flags
default["node_exporter"]["flags"]["collector.textfile.directory"] = ""
