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

consul_register_service "zookeeper" do
  config config
  config_dir  node[cookbook_name]['consul']['config_dir']
  consul_bin  node[cookbook_name]['consul']['bin']
end
