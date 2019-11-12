#
# Cookbook:: prometheus
# Recipe:: user
#
# Copyright:: 2018, BaritoLog.

# Create user for prometheus
user node["prometheus"]["user"] do
  system true
  shell "/bin/false"
  home "/opt/#{node["prometheus"]["user"]}"
  not_if node["prometheus"]["user"] == "root"
end

directory node["prometheus"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["prometheus"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

logrotate_app "prometheus" do
  path "/var/log/prometheus/*.log"
  frequency "daily"
  rotate 7
end
