#
# Cookbook:: zookeeper
# Recipe:: consul_register
#
# Copyright:: 2018, BaritoLog.
#
#

config = {
  "id": "#{node['hostname']}-zookeeper",
  "name": "zookeeper",
  "tags": ["app:"],
  "address": node['ipaddress'],
  "port": node[cookbook_name]['config']['clientPort'],
  "meta": {
    "http_schema": "http"
  }
}

checks = [
  {
    "id": "#{node['hostname']}-zookeeper-hc-tcp",
    "name": "zookeeper",
    "tcp": "#{node['ipaddress']}:#{node[cookbook_name]['config']['clientPort']}",
    "interval": "10s",
    "timeout": "1s"
  },
  {
    "id": "#{node['hostname']}-zookeeper-hc-payload",
    "name": "zookeeper",
    "args": ["/bin/bash", "-c", "echo stat | nc #{node['ipaddress']} #{node[cookbook_name]['config']['clientPort']} | grep -q Connections"],
    "interval": "10s",
    "timeout": "1s"
	  }
]

consul_register_service "zookeeper" do
  config config
  checks checks
  config_dir  node[cookbook_name]['consul']['config_dir']
  consul_bin  node[cookbook_name]['consul']['bin']
end
