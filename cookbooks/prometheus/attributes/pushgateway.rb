#
# Cookbook:: prometheus
# Attributes:: pushgateway
#
# Copyright:: 2018, BaritoLog.

# Pushgateway directory
default["pushgateway"]["dir"] = "#{node["prometheus"]["dir"]}/pushgateway"
default["pushgateway"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["pushgateway"]["binary"] = "#{node["pushgateway"]["dir"]}/pushgateway"

# Pushgateway version
default["pushgateway"]["version"] = "0.9.1"
default["pushgateway"]["checksum"] = "6741f8e8f4d728a907991c7a9f0a7e32e1e9cf339a9795724412e54466f2e8e1"
default["pushgateway"]["binary_url"] = "https://github.com/prometheus/pushgateway/releases/download/v#{node["pushgateway"]["version"]}/pushgateway-#{node["pushgateway"]["version"]}.linux-amd64.tar.gz"

# Pushgateway flags
default["pushgateway"]["flags"]["persistence.file"] = ""
