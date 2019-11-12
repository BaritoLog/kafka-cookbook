#
# Cookbook:: prometheus
# Recipe:: kafka_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["kafka_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["kafka_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus kafka_exporter binary & unpack
ark ::File.basename(node["kafka_exporter"]["dir"]) do
  url node["kafka_exporter"]["binary_url"]
  checksum node["kafka_exporter"]["checksum"]
  version node["kafka_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["kafka_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[kafka_exporter]", :delayed
end

systemd_unit "kafka_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Kafka Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["kafka_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "kafka_exporter")} >> "#{node["kafka_exporter"]["log_dir"]}/kafka_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always
            RestartSec=10

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[kafka_exporter]", :delayed
end

service "kafka_exporter" do
  action %i(enable start)
end
