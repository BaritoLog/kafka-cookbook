#
# Cookbook:: prometheus
# Attributes:: memcached_exporter
#
# Copyright:: 2018, BaritoLog.

# Memcached Exporter directory
default["memcached_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/memcached_exporter"
default["memcached_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["memcached_exporter"]["binary"] = "#{node["memcached_exporter"]["dir"]}/memcached_exporter"

# Memcached Exporter version
default["memcached_exporter"]["version"] = "0.5.0"
default["memcached_exporter"]["checksum"] = "bb07f496ceb63dad9793ad4295205547a4bd20b90628476d64fa96c9a25a020f"
default["memcached_exporter"]["binary_url"] = "https://github.com/prometheus/memcached_exporter/releases/download/v#{node["memcached_exporter"]["version"]}/memcached_exporter-#{node["memcached_exporter"]["version"]}.linux-amd64.tar.gz"

# Memcached Exporter flags
default["memcached_exporter"]["flags"]["log.level"] = "info"
