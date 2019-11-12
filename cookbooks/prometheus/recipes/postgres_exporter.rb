#
# Cookbook:: prometheus
# Recipe:: postgres_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["postgres_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["postgres_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus postgres_exporter binary & unpack
ark ::File.basename(node["postgres_exporter"]["dir"]) do
  url node["postgres_exporter"]["binary_url"]
  checksum node["postgres_exporter"]["checksum"]
  version node["postgres_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["postgres_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[postgres_exporter]", :delayed
end

systemd_unit "postgres_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Postgres Exporter
            After=network.target

            [Service]
            Environment=DATA_SOURCE_NAME='#{node["postgres_exporter"]["config"]["postgres_dsn"]}'
            ExecStart=/bin/bash -ce 'exec #{node["postgres_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "postgres_exporter")} >> "#{node["postgres_exporter"]["log_dir"]}/postgres_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[postgres_exporter]", :delayed
end

service "postgres_exporter" do
  action %i(enable start)
end
