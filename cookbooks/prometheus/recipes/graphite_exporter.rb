#
# Cookbook:: prometheus
# Recipe:: graphite_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["graphite_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["graphite_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus graphite_exporter binary & unpack
ark ::File.basename(node["graphite_exporter"]["dir"]) do
  url node["graphite_exporter"]["binary_url"]
  checksum node["graphite_exporter"]["checksum"]
  version node["graphite_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["graphite_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[graphite_exporter]", :delayed
end

systemd_unit "graphite_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Graphite Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["graphite_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "graphite_exporter")} >> "#{node["graphite_exporter"]["log_dir"]}/graphite_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[graphite_exporter]", :delayed
end

service "graphite_exporter" do
  action %i(enable start)
end
