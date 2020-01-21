#
# Cookbook:: kafka
# Recipe:: kafka_config 
#
# Copyright:: 2018, BaritoLog.

# To be used in service
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['kafka'] ||= {}

# Will be set to false if searchs succeed, at the end of this recipe
node.run_state[cookbook_name]['kafka']['interrupted'] = true

# Get default configuration
config = node[cookbook_name]['kafka']['config'].to_hash

# Get zookeeper cluster list (from search), used in main config
zookeeper_cluster = node.run_state.dig(cookbook_name, 'zookeeper')
return if zookeeper_cluster.nil?

# Get zookeeper hosts
host_map = -> (host) { host + ":2181" }

# Change mapping function when yggdrasil is enabled
if node[cookbook_name]['yggdrasil']['enabled']
  host_map = -> (host) { host['hostname'] + ":2181" }

  # Add hostname to /etc/hosts if requested
  if node[cookbook_name]['yggdrasil']['configure_etc_hosts']
    zookeeper_cluster['hosts'].each do |v|
      hostsfile_entry v['ip'] do
        hostname  v['hostname']
        action    :create
      end
    end
  end
end


zk_connection = zookeeper_cluster['hosts'].
  map(&host_map).
  join(',') 
zk_connection += node[cookbook_name]['kafka']['zk_chroot']
config['zookeeper.connect'] = zk_connection

# Configure replication factor by number of hosts_count attribute
kafka_hosts_count = node[cookbook_name]['kafka']['hosts_count']
if kafka_hosts_count < 3
  config['offsets.topic.replication.factor'] = kafka_hosts_count
  config['min.insync.replicas'] = 1
end

# Write configurations
files = {
  '/etc/kafka/server.properties' => config,
  '/etc/kafka/log4j.properties' => node[cookbook_name]['kafka']['log4j']
}
node.run_state[cookbook_name]['kafka']['conf_files'] = files.keys

files.each do |file, conf|
  template file do
    source 'properties.erb'
    mode '644'
    variables config: conf.sort.to_h
  end
end

# Create Kafka work directories with correct ownership
data_dir = node[cookbook_name]['kafka']['config']['log.dirs']
log_dir = node[cookbook_name]['kafka']['log4j']['kafka.logs.dir']
[data_dir, log_dir].compact.each do |dir|
  directory dir do
    owner node[cookbook_name]['kafka']['user']
    group node[cookbook_name]['kafka']['group']
    mode '0755'
    recursive true
    action :create
  end
end

# Everything was fine
node.run_state[cookbook_name]['kafka']['interrupted'] = false
