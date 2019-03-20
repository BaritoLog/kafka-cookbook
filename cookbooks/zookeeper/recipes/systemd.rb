#
# Cookbook:: zookeeper
# Recipe:: systemd 
#
# Copyright:: 2018, BaritoLog.

# We do not want to continue if the config is incorrect
node.run_state[cookbook_name] ||= {}
return if node.run_state[cookbook_name]['abort?']

# Return if cluster has not been configured
return if node.run_state.dig(cookbook_name, 'hosts').nil?

# Install and launch zookeeper service through systemd
config_path = "#{node[cookbook_name]['prefix_home']}/zookeeper/conf"
install_path = "#{node[cookbook_name]['prefix_home']}/zookeeper"

service_config = {
  classpath: "#{install_path}/zookeeper.jar:#{install_path}/lib/*",
  config_file: "#{config_path}/zoo.cfg",
  log4j_file: "#{config_path}/log4j.properties"
}

# Install service file, reload systemd daemon if necessary
execute 'zookeeper:systemd-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

unit_file = "#{node[cookbook_name]['unit_path']}/zookeeper.service"
template unit_file do
  variables service_config
  mode '0644'
  source 'zookeeper.service.erb'
  notifies :run, 'execute[zookeeper:systemd-reload]', :immediately
end

# Configuration files to be subscribed
config_files = [
  "#{config_path}/zoo.cfg",
  "#{config_path}/log4j.properties",
  "#{node[cookbook_name]['data_dir']}/myid"
].map do |path|
  "template[#{path}]"
end

auto_restart = node[cookbook_name]['auto_restart']
# Enable/Start service
service 'zookeeper' do
  provider Chef::Provider::Service::Systemd
  supports status: true, restart: true, reload: true
  action %i[enable start]
  subscribes :restart, config_files if auto_restart
end
