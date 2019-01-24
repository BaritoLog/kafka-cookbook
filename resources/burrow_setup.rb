property :name, String, name_property: true
property :service_name, String, required: true
property :version, String, required: true
property :prefix_root, String, required: true
property :prefix_bin, String, required: true
property :prefix_temp, String, required: true
property :mirror, String, required: true
property :user, String, required: true
property :group, String, required: true
property :kafka_cluster, Hash, required: true
property :zookeeper_clusters, Array, required: true
property :topic_refresh_interval, Integer, required: true
property :offset_refresh_interval, Integer, required: true

action :create do
  # Create prefix directories
  [
    new_resource.prefix_root,
    new_resource.prefix_bin,
    new_resource.prefix_temp
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

  # Create burrow directory
  directory "#{new_resource.prefix_bin}/#{new_resource.service_name}" do
    owner new_resource.user
    group new_resource.group
    mode 0755
    recursive true
    action :create
  end

  # Put it into temporary directory first
  tar_file = "#{new_resource.prefix_temp}/#{new_resource.name}-#{new_resource.version}.tar.gz"
  remote_file tar_file do
    source new_resource.mirror
    owner new_resource.user
    group new_resource.group
    mode 0755
  end

  # Unzip the tar file
  execute 'extract_burrow_binary' do
    command "tar xzvf #{tar_file} --directory #{new_resource.prefix_bin}/#{new_resource.service_name}"
    cwd "#{new_resource.prefix_temp}"
  end

  execute 'change permission' do
    command "sudo chown -R #{new_resource.group}:#{new_resource.user} #{new_resource.prefix_bin}/#{new_resource.service_name}"
    cwd "#{new_resource.prefix_bin}"
  end

  # Setup burrow configuration
  template '/opt/bin/burrow/config/burrow.toml' do
    source 'burrow_config.erb'
    variables( 
      kafka_cluster: new_resource.kafka_cluster,
      zookeeper_clusters: new_resource.zookeeper_clusters,
      topic_refresh_interval: new_resource.topic_refresh_interval,
      offset_refresh_interval: new_resource.offset_refresh_interval
      )
    mode '0644'
  end

end
