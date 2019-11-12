#
# Cookbook:: prometheus
# Attributes:: zfs_exporter
#
# Copyright:: 2018, BaritoLog.

# Statsd Exporter directory
default["zfs_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/zfs_exporter"
default["zfs_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["zfs_exporter"]["binary"] = "#{node["zfs_exporter"]["dir"]}/zfs_exporter"

# Statsd Exporter version
default["zfs_exporter"]["version"] = "0.0.3"
default["zfs_exporter"]["checksum"] = "941891208a9b500b94670061c21e267354f328e17446f39eb0999452403d6a40"
default["zfs_exporter"]["binary_url"] = "https://github.com/pdf/zfs_exporter/releases/download/v#{node["zfs_exporter"]["version"]}/zfs_exporter-#{node["zfs_exporter"]["version"]}.linux-amd64.tar.gz"
default["zfs_exporter"]["flags"] = []
