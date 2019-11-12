#
# Cookbook:: prometheus
# Attributes:: lxd_exporter
#
# Copyright:: 2018, BaritoLog.

default["lxd_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/lxd_exporter"
default["lxd_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["lxd_exporter"]["binary"] = "#{node["lxd_exporter"]["dir"]}/lxd_exporter"

default["lxd_exporter"]["version"] = "0.2.1"
default["lxd_exporter"]["checksum"] = "ebc5efb5167fc25a1c5342725e398a928ae346234175651854809e8797e4c12c"
default["lxd_exporter"]["binary_url"] = "https://github.com/BaritoLog/lxd_exporter/releases/download/v#{node["lxd_exporter"]["version"]}/lxd_exporter-#{node["lxd_exporter"]["version"]}.linux-amd64.tar.xz"

default["lxd_exporter"]["lxd_socket"] = "/var/snap/lxd/common/lxd/unix.socket"

default["lxd_exporter"]["flags"]["port"] = "9142"
