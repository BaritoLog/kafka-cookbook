#
# Cookbook:: kafka
# Recipe:: kafka_consul_register
#
# Copyright:: 2018, BaritoLog.
#
#

config = {
  "id": "#{node['hostname']}-kafka",
  "name": "kafka",
  "tags": ["app:"],
  "address": node['ipaddress'],
  "port": node[cookbook_name]['kafka']['port']
}

consul_register_service 'kafka' do
  config config
  config_dir  node[cookbook_name]['consul']['config_dir']
  consul_bin  node[cookbook_name]['consul']['bin']
end
