#
# Cookbook:: burrow
# Recipe:: burrow
#
# Copyright:: 2018, BaritoLog.
#
#

service_name = node[cookbook_name]['burrow']['service_name']

kafka_burrow_service_account node[cookbook_name]['burrow']['user'] do
  group node[cookbook_name]['burrow']['group']
end

kafka_burrow_setup service_name do
  service_name service_name
  version node[cookbook_name]['burrow']['version']
  prefix_temp node[cookbook_name]['prefix_temp']
  prefix_root node[cookbook_name]['prefix_root']
  prefix_bin node[cookbook_name]['prefix_bin']
  mirror node[cookbook_name]['burrow']['mirror']
  user node[cookbook_name]['burrow']['user']
  group node[cookbook_name]['burrow']['group']
  kafka_cluster node[cookbook_name]['burrow']['kafka_cluster']
  zookeeper_clusters node[cookbook_name]['burrow']['zookeeper_clusters']
  topic_refresh_interval node[cookbook_name]['burrow']['topic_refresh_interval']
  offset_refresh_interval node[cookbook_name]['burrow']['offset_refresh_interval']
end

bin = "#{node[cookbook_name]['prefix_bin']}/#{service_name}"
kafka_burrow_systemd service_name do
  systemd_unit node[cookbook_name]['burrow']['systemd_unit']
  bin bin
  prefix_log node[cookbook_name]['burrow']['prefix_log']
  log_file_name node[cookbook_name]['burrow']['log_file_name']
end
