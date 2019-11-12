#
# Cookbook:: prometheus
# Recipe:: redis_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["redis_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["redis_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

log node["redis_exporter"]["binary_url"]
log node["redis_exporter"]["dir"]

# Download prometheus redis_exporter binary & unpack
ark ::File.basename(node["redis_exporter"]["dir"]) do
  url node["redis_exporter"]["binary_url"]
  checksum node["redis_exporter"]["checksum"]
  version node["redis_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["redis_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[redis_exporter]", :delayed
end

systemd_unit "redis_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Redis Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["redis_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "redis_exporter")} >> "#{node["redis_exporter"]["log_dir"]}/redis_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[redis_exporter]", :delayed
end

service "redis_exporter" do
  action %i(enable start)
end
