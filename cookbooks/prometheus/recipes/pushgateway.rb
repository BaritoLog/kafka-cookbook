#
# Cookbook:: prometheus
# Recipe:: pushgateway
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["pushgateway"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["pushgateway"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus pushgateway binary & unpack
ark ::File.basename(node["pushgateway"]["dir"]) do
  url node["pushgateway"]["binary_url"]
  checksum node["pushgateway"]["checksum"]
  version node["pushgateway"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["pushgateway"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[pushgateway]", :delayed
end

systemd_unit "pushgateway.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Pushgateway
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["pushgateway"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "pushgateway")} >> "#{node["pushgateway"]["log_dir"]}/pushgateway.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[pushgateway]", :delayed
end

service "pushgateway" do
  action %i(enable start)
end
