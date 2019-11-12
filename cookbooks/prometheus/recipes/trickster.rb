#
# Cookbook:: prometheus
# Recipe:: trickster
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["trickster"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["trickster"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["trickster"]["cache_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus trickster binary & unpack
binary_file = node["trickster"]["binary"]
archive_file = "/tmp/trickster-#{node["trickster"]["version"]}.gz"

remote_file archive_file do
  source node["trickster"]["binary_url"]
  checksum node["trickster"]["checksum"]
  notifies :run, "execute[extract-trickster]", :immediately
end

execute "extract-trickster" do
  command "test ! -f '#{binary_file}' || mv '#{binary_file}' '#{binary_file}.bak' && gunzip -c #{archive_file} > #{binary_file} && chmod 755 #{binary_file}"
  user node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :nothing
  notifies :restart, "service[trickster]", :delayed
end

template node["trickster"]["flags"]["config"] do
  source "trickster.conf.erb"
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0644"
  notifies :restart, "service[trickster]", :delayed
end

systemd_unit "trickster.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Trickster
            After=network.target
            Documentation=https://github.com/Comcast/trickster

            [Service]
            Type=simple
            ExecStart=/bin/bash -ce 'exec #{node["trickster"]["binary"]} #{Gitlab::Prometheus.flags_for(node, "trickster")} >> "#{node["trickster"]["log_dir"]}/trickster.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always
            KillMode=process
            MemoryLimit=#{node["trickster"]["config"]["memory_kb"]}K
            RestartSec=5s

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[trickster]", :delayed
end

service "trickster" do
  action %i(enable start)
end
