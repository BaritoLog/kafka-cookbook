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

# Copy configuration from different repository
git "#{node["prometheus"]["dir"]}/#{node["prometheus"]["runbooks"]["repo_name"]}" do
  repository node["prometheus"]["runbooks"]["repo_url"]
  revision node["prometheus"]["runbooks"]["branch"]
  action :sync
  notifies :restart, "service[prometheus]", :delayed
end

link node["prometheus"]["config"]["rules_dir"] do
  to "#{node["prometheus"]["dir"]}/#{node["prometheus"]["runbooks"]["repo_name"]}/#{node["prometheus"]["runbooks"]["dir"]}/rules"
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
end

link node["prometheus"]["config"]["alerting_rules_dir"] do
  to "#{node["prometheus"]["dir"]}/#{node["prometheus"]["runbooks"]["repo_name"]}/#{node["prometheus"]["runbooks"]["dir"]}/alerts"
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
end

link node["prometheus"]["config"]["recording_rules_dir"] do
  to "#{node["prometheus"]["dir"]}/#{node["prometheus"]["runbooks"]["repo_name"]}/#{node["prometheus"]["runbooks"]["dir"]}/recordings"
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
end

directory node["prometheus"]["config"]["inventory_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

config = {
  "global" => {
    "scrape_interval" => node["prometheus"]["config"]["scrape_interval"],
    "scrape_timeout" => node["prometheus"]["config"]["scrape_timeout"],
    "evaluation_interval" => node["prometheus"]["config"]["evaluation_interval"],
    "external_labels" => node["prometheus"]["config"]["external_labels"],
  },
  "remote_write" => node["prometheus"]["config"]["remote_write"],
  "remote_read" => node["prometheus"]["config"]["remote_read"],
  "scrape_configs" => parse_jobs(node["prometheus"]["config"]["scrape_configs"], node["prometheus"]["config"]["inventory_dir"]),
  "alerting" => node["prometheus"]["config"]["alerting"],
  "rule_files" => node["prometheus"]["config"]["rule_files"],
}

file "Prometheus config" do
  path node["prometheus"]["flags"]["config.file"]
  content hash_to_yaml(config)
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0644"
  notifies :restart, "service[prometheus]"
end

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
