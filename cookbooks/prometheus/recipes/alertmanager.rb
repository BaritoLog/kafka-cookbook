#
# Cookbook:: prometheus
# Recipe:: alertmanager
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["alertmanager"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["alertmanager"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

# Download prometheus alertmanager binary & unpack
ark ::File.basename(node["alertmanager"]["dir"]) do
  url node["alertmanager"]["binary_url"]
  checksum node["alertmanager"]["checksum"]
  version node["alertmanager"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["alertmanager"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[alertmanager]", :delayed
end

config = {
  "global" => {
    "resolve_timeout" => node["alertmanager"]["config"]["resolve_timeout"],
    "smtp_smarthost" => node["alertmanager"]["config"]["smtp_smarthost"],
    "smtp_from" => node["alertmanager"]["config"]["smtp_from"],
    "smtp_auth_username" => node["alertmanager"]["config"]["smtp_auth_username"],
    "smtp_auth_password" => node["alertmanager"]["config"]["smtp_auth_password"],
    "hipchat_auth_token" => node["alertmanager"]["config"]["hipchat_auth_token"],
    "hipchat_api_url" => node["alertmanager"]["config"]["hipchat_api_url"],
  },
  "route" => node["alertmanager"]["config"]["route"],
  "inhibit_rules" => node["alertmanager"]["config"]["inhibit_rules"],
  "receivers" => node["alertmanager"]["config"]["receivers"],
  "templates" => node["alertmanager"]["config"]["templates"],
}

file "alertmanager config" do
  path node["alertmanager"]["flags"]["config.file"]
  content hash_to_yaml(config)
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0644"
  notifies :restart, "service[alertmanager]"
end

systemd_unit "alertmanager.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Alertmanager
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["alertmanager"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "alertmanager")} >> "#{node["alertmanager"]["log_dir"]}/alertmanager.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always
            WorkingDirectory=#{node["alertmanager"]["dir"]}

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[alertmanager]", :delayed
end

service "alertmanager" do
  action %i(enable start)
end
