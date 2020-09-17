#
# Cookbook:: prometheus
# Recipe:: blackbox_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["blackbox_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["blackbox_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus blackbox_exporter binary & unpack
ark ::File.basename(node["blackbox_exporter"]["dir"]) do
  url node["blackbox_exporter"]["binary_url"]
  checksum node["blackbox_exporter"]["checksum"]
  version node["blackbox_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["blackbox_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[blackbox_exporter]", :delayed
end

execute 'enable ICMP probe permission' do
  cwd node["blackbox_exporter"]["dir"]
  command 'sudo setcap cap_net_raw+ep blackbox_exporter'
end

file node["blackbox_exporter"]["flags"]["config.file"] do
  content node["blackbox_exporter"]["config_content"]
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  notifies :reload, "service[blackbox_exporter]", :delayed
end

systemd_unit "blackbox_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Blackbox Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["blackbox_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "blackbox_exporter")} >> "#{node["blackbox_exporter"]["log_dir"]}/blackbox_exporter.log" 2>&1'
            ExecReload=/bin/kill -HUP $MAINPID
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[blackbox_exporter]", :delayed
end

service "blackbox_exporter" do
  action %i(enable start)
end
