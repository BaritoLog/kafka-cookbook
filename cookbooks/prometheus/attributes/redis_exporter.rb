#
# Cookbook:: prometheus
# Attributes:: redis_exporter
#
# Copyright:: 2018, BaritoLog.

# Redis Exporter directory
default["redis_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/redis_exporter"
default["redis_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["redis_exporter"]["binary"] = "#{node["redis_exporter"]["dir"]}/redis_exporter"

# Redis Exporter version
default["redis_exporter"]["version"] = "1.0.4"
default["redis_exporter"]["checksum"] = "6b2617cc60564e52421a5bd8acd9e47e799e5dbcee11602ebdf8499bc43cefde"
default["redis_exporter"]["binary_url"] = "https://github.com/oliver006/redis_exporter/releases/download/v#{node["redis_exporter"]["version"]}/redis_exporter-v#{node["redis_exporter"]["version"]}.linux-amd64.tar.gz"

# Redis Exporter flags
default["redis_exporter"]["flags"]["log-format"] = "txt"
