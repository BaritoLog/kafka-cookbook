#
# Cookbook:: kafka
# Recipe:: burrow_install
#
# Copyright:: 2018, BaritoLog.
#
#

include_recipe "#{cookbook_name}::burrow_search"

service_name = node[cookbook_name]['burrow']['service_name']

kafka_burrow_service_account node[cookbook_name]['burrow']['user'] do
  group node[cookbook_name]['burrow']['group']
end

kafka_burrow_setup service_name do
  prefix_root node[cookbook_name]['burrow']['prefix_root']
  prefix_bin node[cookbook_name]['burrow']['prefix_bin']
  prefix_temp node[cookbook_name]['burrow']['prefix_temp']
  prefix_log node[cookbook_name]['burrow']['prefix_log']
  user node[cookbook_name]['burrow']['user']
  group node[cookbook_name]['burrow']['group']
  version node[cookbook_name]['burrow']['version']
  mirror node[cookbook_name]['burrow']['mirror']
  zookeeper_clusters node.run_state[cookbook_name]['burrow']['zookeeper_clusters']
  kafka_cluster node[cookbook_name]['burrow']['kafka_cluster']
  yggdrasil_config node[cookbook_name]['yggdrasil']
  topic_refresh_interval node[cookbook_name]['burrow']['topic_refresh_interval']
  offset_refresh_interval node[cookbook_name]['burrow']['offset_refresh_interval']
  burrow_port node[cookbook_name]['burrow']['port']
end

kafka_burrow_systemd service_name do
  init_command node[cookbook_name]['burrow']['init_command']
end
