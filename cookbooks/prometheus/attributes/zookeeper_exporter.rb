#
# Cookbook:: prometheus
# Attributes:: zookeeper_exporter
#
# Copyright:: 2018, BaritoLog.

# Kafka Exporter directory
default["zookeeper_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/zookeeper_exporter"
default["zookeeper_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["zookeeper_exporter"]["binary"] = "#{node["zookeeper_exporter"]["dir"]}/zookeeper_exporter"

# Kafka Exporter version
default["zookeeper_exporter"]["version"] = "1.0.1"
default["zookeeper_exporter"]["checksum"] = "c5522a029bd21be7021a5aa42d48cbd541975b641b9bba8315ce9c769051f91e"
default["zookeeper_exporter"]["binary_url"] = "https://github.com/carlpett/zookeeper_exporter/releases/download/v#{node["zookeeper_exporter"]["version"]}/zookeeper_exporter-#{node["zookeeper_exporter"]["version"]}.linux-amd64.tar.gz"

# Kafka Exporter flags
default["zookeeper_exporter"]["flags"]["log-level"] = "info"
default["zookeeper_exporter"]["flags"]["zookeeper"] = "localhost:2181"