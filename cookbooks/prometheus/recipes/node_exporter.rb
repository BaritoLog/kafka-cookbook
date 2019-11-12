#
# Cookbook:: prometheus
# Recipe:: node_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["node_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["node_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus node_exporter binary & unpack
ark ::File.basename(node["node_exporter"]["dir"]) do
  url node["node_exporter"]["binary_url"]
  checksum node["node_exporter"]["checksum"]
  version node["node_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["node_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[node_exporter]", :delayed
end

systemd_unit "node_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Node Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["node_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "node_exporter")} >> "#{node["node_exporter"]["log_dir"]}/node_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[node_exporter]", :delayed
end

service "node_exporter" do
  action %i(enable start)
end
