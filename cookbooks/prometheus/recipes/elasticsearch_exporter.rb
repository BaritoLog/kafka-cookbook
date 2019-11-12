#
# Cookbook:: prometheus
# Recipe:: elasticsearch_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["elasticsearch_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["elasticsearch_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus elasticsearch_exporter binary & unpack
ark ::File.basename(node["elasticsearch_exporter"]["dir"]) do
  url node["elasticsearch_exporter"]["binary_url"]
  checksum node["elasticsearch_exporter"]["checksum"]
  version node["elasticsearch_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["elasticsearch_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[elasticsearch_exporter]", :delayed
end

systemd_unit "elasticsearch_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Elasticsearch Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["elasticsearch_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "elasticsearch_exporter")} >> "#{node["elasticsearch_exporter"]["log_dir"]}/elasticsearch_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[elasticsearch_exporter]", :delayed
end

service "elasticsearch_exporter" do
  action %i(enable start)
end
