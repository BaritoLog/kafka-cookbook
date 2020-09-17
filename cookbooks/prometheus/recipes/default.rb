#
# Cookbook:: prometheus
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.

require "yaml"

include_recipe "prometheus::user"

directory node["prometheus"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus binary & unpack
ark ::File.basename(node["prometheus"]["dir"]) do
  url node["prometheus"]["binary_url"]
  checksum node["prometheus"]["checksum"]
  version node["prometheus"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["prometheus"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[prometheus]", :delayed
end

include_recipe "prometheus::config"

systemd_unit "prometheus.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Server
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["prometheus"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "prometheus")} >> "#{node["prometheus"]["log_dir"]}/prometheus.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[prometheus]", :delayed
end

service "prometheus" do
  action %i(enable start)
  restart_command "(systemctl | grep prome | grep active ) && curl -X POST http://localhost:9090/-/reload || systemctl restart prometheus"
end
