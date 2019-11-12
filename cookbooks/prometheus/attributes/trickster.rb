#
# Cookbook:: prometheus
# Attributes:: trickster
#
# Copyright:: 2018, BaritoLog.

# Trickster version
default["trickster"]["version"] = "0.1.10"
default["trickster"]["checksum"] = "a33aeb3c5243b067f9ede0c250997825b5a244631b9c4a07dde86a387b4fd809"
default["trickster"]["binary_url"] = "https://github.com/Comcast/trickster/releases/download/v#{node["trickster"]["version"]}/trickster-#{node["trickster"]["version"]}.linux-amd64.gz"

# Trickster directory
default["trickster"]["dir"] = "#{node["prometheus"]["dir"]}/trickster"
default["trickster"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["trickster"]["binary"] = "#{node["trickster"]["dir"]}/trickster"
default["trickster"]["cache_dir"] = "#{node["trickster"]["dir"]}/cache"

# Trickster flags
default["trickster"]["flags"]["config"] = "#{node["trickster"]["dir"]}/trickster.conf"

# Trickster configuration
# Allocate 80% of memory to Trickster by default.
default["trickster"]["config"]["memory_kb"] = (node["memory"]["total"].to_i * 0.8).to_i
default["trickster"]["config"]["proxy_server"]["listen_port"] = 9095
default["trickster"]["config"]["proxy_server"]["listen_address"] = "127.0.0.1"
default["trickster"]["config"]["cache"]["cache_type"] = "filesystem"
default["trickster"]["config"]["cache"]["record_ttl_secs"] = 3600
default["trickster"]["config"]["cache"]["reap_sleep_ms"] = 1000
default["trickster"]["config"]["cache"]["compression"] = "true"
default["trickster"]["config"]["cache"]["options"] = {
  "filesystem" => {
    "cache_path" => node["trickster"]["cache_dir"],
  },
}
default["trickster"]["config"]["origins"] = {}
default["trickster"]["config"]["metrics"]["listen_port"] = 9195
default["trickster"]["config"]["metrics"]["listen_address"] = "0.0.0.0"
default["trickster"]["config"]["logging"]["log_level"] = "info"
