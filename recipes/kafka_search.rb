#
# Cookbook:: kafka-cookbook
# Recipe:: kafka_search 
#
# Copyright:: 2018, BaritoLog.

# Use ClusterSearch
::Chef::Recipe.send(:include, ClusterSearch)

# Search zookeeper cluster
zookeeper_cluster = cluster_search(node[cookbook_name]['zookeeper'])
return if zookeeper_cluster.nil? # Not enough nodes

node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['zookeeper'] ||= {}
node.run_state[cookbook_name]['zookeeper']['hosts'] = zookeeper_cluster['hosts']
