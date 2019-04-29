property :name, String, name_property: true
property :prefix_root, String, required: true
property :prefix_bin, String, required: true
property :prefix_temp, String, required: true
property :prefix_log, String, required: true
property :user, String, required: true
property :group, String, required: true
property :version, String, required: true
property :mirror, String, required: true
property :zookeeper_clusters, Array, required: true
property :kafka_cluster, Hash, required: true
property :yggdrasil_config, Hash, required: true
property :topic_refresh_interval, Integer, required: true
property :offset_refresh_interval, Integer, required: true
property :burrow_port, Integer, required: true

action :create do
  root_path = "#{new_resource.prefix_root}/#{new_resource.name}"
  config_path = "#{root_path}/config"
  zookeeper_clusters = new_resource.zookeeper_clusters
  kafka_zookeeper_ips = new_resource.kafka_cluster['zookeeper_ips']

  # Change mapping function when yggdrasil is enabled
  if new_resource.yggdrasil_config['enabled']
    zookeeper_clusters = zookeeper_clusters.map { |host| host['hostname'] + ":2181" }
    kafka_zookeeper_ips = zookeeper_clusters

    # Add hostname to /etc/hosts if requested
    if new_resource.yggdrasil_config['configure_etc_hosts']
      new_resource.zookeeper_clusters.each do |v|
        hostsfile_entry v['ip'] do
          hostname  v['hostname']
          action    :create
        end
      end
    end
  else
    zookeeper_clusters = zookeeper_clusters.map { |host| host + ":2181" }
  end

  [
    new_resource.prefix_root,
    new_resource.prefix_bin,
    new_resource.prefix_temp,
    new_resource.prefix_log
  ].uniq.each do |dir_path|
    directory "#{cookbook_name}:#{dir_path}" do
      path dir_path
      mode 0755
      recursive true
      action :create
    end
  end

  [
    root_path,
    config_path
  ].uniq.each do |dir_path|
    directory "#{cookbook_name}:#{dir_path}" do
      path dir_path
      owner new_resource.user
      group new_resource.group
      mode 0755
      recursive true
      action :create
    end
  end

  tar_file = "#{new_resource.prefix_temp}/#{new_resource.name}-#{new_resource.version}"
  remote_file tar_file do
    source new_resource.mirror
    owner new_resource.user
    group new_resource.group
    mode 0755
  end

  execute 'extract burrow (only the binary)' do
    command "tar xzvf #{tar_file} --directory #{new_resource.prefix_bin} burrow"
    cwd new_resource.prefix_temp
  end

  execute 'change permission' do
    command "sudo chown -R #{new_resource.group}:#{new_resource.user} #{new_resource.prefix_bin}/#{new_resource.name}"
    cwd new_resource.prefix_bin
  end

  template "#{config_path}/burrow.toml" do
    source 'burrow_config.erb'
    variables(
      root_path: root_path,
      zookeeper_clusters: zookeeper_clusters,
      kafka_cluster: new_resource.kafka_cluster,
      kafka_zookeeper_ips: kafka_zookeeper_ips,
      topic_refresh_interval: new_resource.topic_refresh_interval,
      offset_refresh_interval: new_resource.offset_refresh_interval,
      burrow_port: new_resource.burrow_port
    )
    owner new_resource.user
    group new_resource.group
    mode 0644
  end
end
