#
# Cookbook:: prometheus
# Attributes:: elasticsearch_exporter
#
# Copyright:: 2018, BaritoLog.

# Elasticsearch Exporter directory
default["elasticsearch_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/elasticsearch_exporter"
default["elasticsearch_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["elasticsearch_exporter"]["binary"] = "#{node["elasticsearch_exporter"]["dir"]}/elasticsearch_exporter"

# Elasticsearch Exporter version
default["elasticsearch_exporter"]["version"] = "1.1.0"
default["elasticsearch_exporter"]["checksum"] = "1d2444d7cbf321cb31d58d2fecc08c8bc90bbcec581f8a1ddb987f9ef425482b"
default["elasticsearch_exporter"]["binary_url"] = "https://github.com/justwatchcom/elasticsearch_exporter/releases/download/v#{node["elasticsearch_exporter"]["version"]}/elasticsearch_exporter-#{node["elasticsearch_exporter"]["version"]}.linux-amd64.tar.gz"

# Elasticsearch Exporter flags
default["elasticsearch_exporter"]["flags"]["es.timeout"] = "15s"
default["elasticsearch_exporter"]["flags"]["es.indices"] = true
default["elasticsearch_exporter"]["flags"]["es.indices_settings"] = true
default["elasticsearch_exporter"]["flags"]["es.cluster_settings"] = true
default["elasticsearch_exporter"]["flags"]["es.shards"] = true
default["elasticsearch_exporter"]["flags"]["es.snapshots"] = true
default["elasticsearch_exporter"]["flags"]["es.uri"] = "http://#{node["ipaddress"]}:9200"
