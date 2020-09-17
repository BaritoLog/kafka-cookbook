#
# Cookbook:: prometheus
# Attributes:: blackbox_exporter
#
# Copyright:: 2018, BaritoLog.

# Blackbox Exporter directory
default["blackbox_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/blackbox_exporter"
default["blackbox_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["blackbox_exporter"]["binary"] = "#{node["blackbox_exporter"]["dir"]}/blackbox_exporter"

# Blackbox Exporter version
default["blackbox_exporter"]["version"] = "0.14.0"
default["blackbox_exporter"]["checksum"] = "a2918a059023045cafb911272c88a9eb83cdac9a8a5e8e74844b5d6d27f19117"
default["blackbox_exporter"]["binary_url"] = "https://github.com/prometheus/blackbox_exporter/releases/download/v#{node['blackbox_exporter']['version']}/blackbox_exporter-#{node['blackbox_exporter']['version']}.linux-amd64.tar.gz"

# Blackbox Exporter flags
default["blackbox_exporter"]["flags"]["config.file"] = "#{node["blackbox_exporter"]["dir"]}/blackbox.yml"

default["blackbox_exporter"]["config_content"] = %q(
modules:
  http_2xx:
    prober: http
  http_post_2xx:
    prober: http
    http:
      method: POST
  tcp_connect:
    prober: tcp
  icmp:
    prober: icmp
)