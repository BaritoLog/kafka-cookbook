#
# Cookbook:: kafka
# Recipe:: kafka_search 
#
# Copyright:: 2018, BaritoLog.
require 'json'

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['zookeeper'] ||= {}
node.run_state[cookbook_name]['zookeeper']['hosts'] = node[cookbook_name]['zookeeper']['hosts'] || []

# Override zookeeper hosts from yggdrasil, if enabled
if node[cookbook_name]['yggdrasil']['enabled']
  config_path = File.join(node[cookbook_name]['yggdrasil']['config_dir'], 'yggdrasil.json')
  config = JSON.parse(File.read(config_path))

  node.run_state[cookbook_name]['zookeeper']['hosts'] ||= {}
  node.run_state[cookbook_name]['zookeeper']['hosts'] = JSON.parse(config['zookeeper_hosts'])
end
