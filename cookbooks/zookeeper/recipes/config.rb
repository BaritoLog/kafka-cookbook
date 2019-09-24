#
# Cookbook:: zookeeper
# Recipe:: config 
#
# Copyright:: 2018, BaritoLog.

# Create zookeeper log & data directories
%w[log_dir data_dir].each do |dir|
  directory node[cookbook_name][dir] do
    user node[cookbook_name]['user']
    group node[cookbook_name]['group']
    mode '0755'
    recursive true
  end
end

# Get cluster list (from search), used in main config
cluster = node.run_state.dig(cookbook_name, 'hosts')
if cluster.nil?
  node.run_state[cookbook_name]['abort?'] = true
  return
end

config = node[cookbook_name]['config'].dup

# Generate config
if node[cookbook_name]['yggdrasil']['enabled']
  cluster.each_with_index do |v, i|
    config["server.#{i + 1}"] = "#{v['hostname']}:2888:3888"
  end

  if node[cookbook_name]['yggdrasil']['configure_etc_hosts']
    cluster.each do |v|
      hostsfile_entry "#{v['ip']}" do
        hostname  "#{v['hostname']}"
        action    :create
      end
    end
  end
else
  cluster.each_with_index do |v, i|
    config["server.#{i + 1}"] = "#{v}:2888:3888"
  end
end

# General zookeeper config
config_path = "#{node[cookbook_name]['prefix_home']}/zookeeper/conf"

template "#{config_path}/zoo.cfg" do
  variables config: config
  mode '0644'
  source 'zoo.cfg.erb'
end

# Log4j
template "#{config_path}/log4j.properties" do
  source 'properties.erb'
  mode '644'
  variables config: node[cookbook_name]['log4j']
end

# Create myid file
template "#{node[cookbook_name]['data_dir']}/myid" do
  variables my_id: node.run_state.dig(cookbook_name, 'my_id')
  mode '0644'
  source 'myid.erb'
end
