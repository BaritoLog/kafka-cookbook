#
# Cookbook:: prometheus
# Attributes:: haproxy_exporter
#
# Copyright:: 2018, BaritoLog.

# Haproxy Exporter directory
default["haproxy_exporter"]["dir"] = "#{node["prometheus"]["dir"]}/haproxy_exporter"
default["haproxy_exporter"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["haproxy_exporter"]["binary"] = "#{node["haproxy_exporter"]["dir"]}/haproxy_exporter"

# Haproxy Exporter version
default["haproxy_exporter"]["version"] = "0.10.0"
default["haproxy_exporter"]["checksum"] = "08150728e281f813a8fcfff4b336f16dbfe4268a1c7510212c8cff2579b10468"
default["haproxy_exporter"]["binary_url"] = "https://github.com/prometheus/haproxy_exporter/releases/download/v#{node["haproxy_exporter"]["version"]}/haproxy_exporter-#{node["haproxy_exporter"]["version"]}.linux-amd64.tar.gz"

# Haproxy Exporter flags
default["haproxy_exporter"]["flags"]["log.level"] = "info"
default["haproxy_exporter"]["flags"]["haproxy.ssl-verify"] = false
default["haproxy_exporter"]["flags"]["haproxy.scrape-uri"] = "http://#{node["ipaddress"]}:1936/stats;csv"
