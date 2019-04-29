# Cookbook:: kafka
# Recipe:: burrow_search
#
# Copyright:: 2018, BaritoLog.
#
#

require 'json'

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['burrow'] ||= {}
node.run_state[cookbook_name]['burrow']['zookeeper_clusters'] = node[cookbook_name]['burrow']['zookeeper_clusters'] || []

# Override zookeeper hosts from yggdrasil, if enabled
if node[cookbook_name]['yggdrasil']['enabled']
  config_path = File.join(node[cookbook_name]['yggdrasil']['config_dir'], 'yggdrasil.json')
  config = JSON.parse(File.read(config_path))

  node.run_state[cookbook_name]['burrow']['zookeeper_clusters'] = JSON.parse(config['zookeeper_hosts'])
end
