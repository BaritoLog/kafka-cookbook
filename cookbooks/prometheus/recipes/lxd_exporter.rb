#
# Cookbook:: prometheus
# Recipe:: kibana_exporter
#
# Copyright:: 2019, BaritoLog.

include_recipe "prometheus::user"

group "lxd" do
  append true
  members "prometheus"
end

ark ::File.basename(node["lxd_exporter"]["dir"]) do
  url node["lxd_exporter"]["binary_url"]
  checksum node["lxd_exporter"]["checksum"]
  version node["lxd_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["lxd_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[lxd_exporter]", :delayed
end

systemd_unit "lxd_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus LXD Exporter
            After=network.target

            [Service]
            Environment=LXD_SOCKET=#{node["lxd_exporter"]["lxd_socket"]}
            ExecStart=/bin/bash -ce 'exec #{node["lxd_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "lxd_exporter")} >> "#{node["lxd_exporter"]["log_dir"]}/lxd_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[lxd_exporter]", :delayed
end

service "lxd_exporter" do
  action %i(enable start)
end
