#
# Cookbook:: kafka
# Recipe:: kafka_consul_register
#
# Copyright:: 2018, BaritoLog.
#
#

# Install netcat
apt_package 'netcat'

config = {
  "id": "#{node['hostname']}-kafka",
  "name": "kafka",
  "tags": ["app:"],
  "address": node['ipaddress'],
  "port": node[cookbook_name]['kafka']['port']
}

checks = [
  {
    "id": "#{node['hostname']}-hc-tcp",
    "name": "kafka",
    "tcp": "#{node['ipaddress']}:#{node[cookbook_name]['kafka']['port']}",
    "interval": "10s",
    "timeout": "1s"
  },
  {
    "id": "#{node['hostname']}-hc-payload",
    "name": "kafka",
    "args": ["/bin/bash", "-c", "nc -vz #{node['ipaddress']} #{node[cookbook_name]['kafka']['port']} 2>&1 | grep 'open\\\|succeeded'"],
    "interval": "10s",
    "timeout": "1s"
  }
]

consul_register_service 'kafka' do
  config config
  checks checks
  config_dir  node[cookbook_name]['consul']['config_dir']
  consul_bin  node[cookbook_name]['consul']['bin']
end
