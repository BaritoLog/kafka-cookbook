#
# Cookbook:: prometheus
# Recipe:: haproxy_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["haproxy_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["haproxy_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus haproxy_exporter binary & unpack
ark ::File.basename(node["haproxy_exporter"]["dir"]) do
  url node["haproxy_exporter"]["binary_url"]
  checksum node["haproxy_exporter"]["checksum"]
  version node["haproxy_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["haproxy_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[haproxy_exporter]", :delayed
end

systemd_unit "haproxy_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Haproxy Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["haproxy_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "haproxy_exporter")} >> "#{node["haproxy_exporter"]["log_dir"]}/haproxy_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[haproxy_exporter]", :delayed
end

service "haproxy_exporter" do
  action %i(enable start)
end
