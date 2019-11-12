#
# Cookbook:: prometheus
# Recipe:: fluentd_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["fluentd_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["fluentd_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus fluentd_exporter binary & unpack
ark ::File.basename(node["fluentd_exporter"]["dir"]) do
  url node["fluentd_exporter"]["binary_url"]
  checksum node["fluentd_exporter"]["checksum"]
  version node["fluentd_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["fluentd_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[fluentd_exporter]", :delayed
end

systemd_unit "fluentd_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Fluentd Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["fluentd_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "fluentd_exporter")} >> "#{node["fluentd_exporter"]["log_dir"]}/fluentd_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[fluentd_exporter]", :delayed
end

service "fluentd_exporter" do
  action %i(enable start)
end
