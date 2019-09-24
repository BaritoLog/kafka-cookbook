#
# Cookbook:: zookeeper
# Recipe:: search 
#
# Copyright:: 2018, BaritoLog.
require 'json'

# Don't continue if these variables are empty
node.run_state[cookbook_name] ||= {}
unless node[cookbook_name]['my_id'].is_a?(Integer)
  node.run_state[cookbook_name]['abort?'] = true
  return
end

if node[cookbook_name]['yggdrasil']['enabled']
  config_path = File.join(node[cookbook_name]['yggdrasil']['config_dir'], 'yggdrasil.json')
  config = JSON.parse(File.read(config_path))

  node.run_state[cookbook_name]['hosts'] ||= {}
  node.run_state[cookbook_name]['hosts'] = JSON.parse(config["zookeeper_hosts"])
elsif !node[cookbook_name]['hosts'].empty?
  node.run_state[cookbook_name]['hosts'] = node[cookbook_name]['hosts']
else
  node.run_state[cookbook_name]['abort?'] = true
  return
end

node.run_state[cookbook_name]['my_id'] = node[cookbook_name]['my_id']
