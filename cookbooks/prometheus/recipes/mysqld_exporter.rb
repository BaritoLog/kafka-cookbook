#
# Cookbook:: prometheus
# Recipe:: mysqld_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["mysqld_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["mysqld_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus mysqld_exporter binary & unpack
ark ::File.basename(node["mysqld_exporter"]["dir"]) do
  url node["mysqld_exporter"]["binary_url"]
  checksum node["mysqld_exporter"]["checksum"]
  version node["mysqld_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["mysqld_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[mysqld_exporter]", :delayed
end

systemd_unit "mysqld_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Mysqld Exporter
            After=network.target

            [Service]
            Environment=DATA_SOURCE_NAME='#{node["mysqld_exporter"]["config"]["mysql_dsn"]}'
            ExecStart=/bin/bash -ce 'exec #{node["mysqld_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "mysqld_exporter")} >> "#{node["mysqld_exporter"]["log_dir"]}/mysqld_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[mysqld_exporter]", :delayed
end

service "mysqld_exporter" do
  action %i(enable start)
end
