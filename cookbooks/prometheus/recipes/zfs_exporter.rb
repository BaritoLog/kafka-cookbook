#
# Cookbook:: prometheus
# Recipe:: zfs_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["zfs_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["zfs_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus zfs_exporter binary & unpack
ark ::File.basename(node["zfs_exporter"]["dir"]) do
  url node["zfs_exporter"]["binary_url"]
  checksum node["zfs_exporter"]["checksum"]
  version node["zfs_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["zfs_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[zfs_exporter]", :delayed
end

systemd_unit "zfs_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Statsd Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["zfs_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "zfs_exporter")} >> "#{node["zfs_exporter"]["log_dir"]}/zfs_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[zfs_exporter]", :delayed
end

service "zfs_exporter" do
  action %i(enable start)
end
