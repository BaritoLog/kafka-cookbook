#
# Cookbook:: prometheus
# Recipe:: zookeeper_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["zookeeper_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["zookeeper_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus zookeeper_exporter binary & unpack
ark ::File.basename(node["zookeeper_exporter"]["dir"]) do
  url node["zookeeper_exporter"]["binary_url"]
  checksum node["zookeeper_exporter"]["checksum"]
  version node["zookeeper_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["zookeeper_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[zookeeper_exporter]", :delayed
end

systemd_unit "zookeeper_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Zookeeper Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["zookeeper_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "zookeeper_exporter")} >> "#{node["zookeeper_exporter"]["log_dir"]}/zookeeper_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always
            RestartSec=10

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[zookeeper_exporter]", :delayed
end

service "zookeeper_exporter" do
  action %i(enable start)
end
