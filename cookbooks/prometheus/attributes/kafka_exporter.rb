#
# Cookbook:: prometheus
# Attributes:: kafka_exporter
#
# Copyright:: 2018, BaritoLog.

# Kafka Exporter directory
default["kafka_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/kafka_exporter"
default["kafka_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["kafka_exporter"]["binary"] = "#{node["kafka_exporter"]["dir"]}/kafka_exporter"

# Kafka Exporter version
default["kafka_exporter"]["version"] = "1.2.0"
default["kafka_exporter"]["checksum"] = "478e50e08a3104caaa2e60c7997936705b77ce8d187b83ab060de1c69d32fe13"
default["kafka_exporter"]["binary_url"] = "https://github.com/danielqsj/kafka_exporter/releases/download/v#{node["kafka_exporter"]["version"]}/kafka_exporter-#{node["kafka_exporter"]["version"]}.linux-amd64.tar.gz"

# Kafka Exporter flags
default["kafka_exporter"]["flags"]["log.level"] = "info"
default["kafka_exporter"]["flags"]["kafka.server"] = "localhost:9092"
