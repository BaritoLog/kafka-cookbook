#
# Cookbook:: prometheus
# Recipe:: memcached_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["memcached_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["memcached_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus memcached_exporter binary & unpack
ark ::File.basename(node["memcached_exporter"]["dir"]) do
  url node["memcached_exporter"]["binary_url"]
  checksum node["memcached_exporter"]["checksum"]
  version node["memcached_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["memcached_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[memcached_exporter]", :delayed
end

systemd_unit "memcached_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Memcached Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["memcached_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "memcached_exporter")} >> "#{node["memcached_exporter"]["log_dir"]}/memcached_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[memcached_exporter]", :delayed
end

service "memcached_exporter" do
  action %i(enable start)
end
