#
# Cookbook:: prometheus
# Attributes:: mysqld_exporter
#
# Copyright:: 2018, BaritoLog.

# Mysqld Exporter directory
default["mysqld_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/mysqld_exporter"
default["mysqld_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["mysqld_exporter"]["binary"] = "#{node["mysqld_exporter"]["dir"]}/mysqld_exporter"

# Mysqld Exporter version
default["mysqld_exporter"]["version"] = "0.12.1"
default["mysqld_exporter"]["checksum"] = "133b0c281e5c6f8a34076b69ade64ab6cac7298507d35b96808234c4aa26b351"
default["mysqld_exporter"]["binary_url"] = "https://github.com/prometheus/mysqld_exporter/releases/download/v#{node["mysqld_exporter"]["version"]}/mysqld_exporter-#{node["mysqld_exporter"]["version"]}.linux-amd64.tar.gz"

# Mysqld Exporter config
default["mysqld_exporter"]["config"]["mysql_dsn"] = "user:password@(hostname:3306)/"

# Mysqld Exporter flags
default["mysqld_exporter"]["flags"]["log.level"] = "info"
