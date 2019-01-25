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

template '/etc/systemd/system/burrow.service' do
  source 'burrow_service.erb'
  mode '0644'
  variables(
    init_command: node[cookbook_name]['burrow']['init_command']
  )
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
  notifies :restart, "service[#{service_name}]", :delayed
end

execute 'systemctl daemon-reload' do
  action :nothing
end

service service_name do
  provider Object.const_get 'Chef::Provider::Service::Systemd'
  supports status: true, start: true, stop: true, restart: true
  action [:start, :enable]
end
