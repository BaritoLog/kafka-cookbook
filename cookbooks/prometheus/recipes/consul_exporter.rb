#
# Cookbook:: prometheus
# Recipe:: consul_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["consul_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["consul_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus consul_exporter binary & unpack
ark ::File.basename(node["consul_exporter"]["dir"]) do
  url node["consul_exporter"]["binary_url"]
  checksum node["consul_exporter"]["checksum"]
  version node["consul_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["consul_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[consul_exporter]", :delayed
end

systemd_unit "consul_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Consul Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["consul_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "consul_exporter")} >> "#{node["consul_exporter"]["log_dir"]}/consul_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[consul_exporter]", :delayed
end

service "consul_exporter" do
  action %i(enable start)
end
