#
# Cookbook:: kafka
# Recipe:: kafka_search 
#
# Copyright:: 2018, BaritoLog.

# Don't continue if these variables are empty
return if node[cookbook_name]['zookeeper']['hosts'].empty?

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['zookeeper'] ||= {}
node.run_state[cookbook_name]['zookeeper']['hosts'] = node[cookbook_name]['zookeeper']['hosts']
