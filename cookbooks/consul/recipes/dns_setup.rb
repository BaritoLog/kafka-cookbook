#
# Cookbook:: consul
# Recipe:: dns_setup
#
# Copyright:: 2019, BaritoLog.
#
#
dns_host = node[cookbook_name]['resolved']['dns_host']
domain = node[cookbook_name]['resolved']['domain']

execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

template '/etc/systemd/resolved.conf' do
  source 'systemd/resolved.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables dns_host: dns_host, domain: domain
  notifies :reload_or_restart, 'systemd_unit[systemd-resolved]', :immediately
end

systemd_unit 'systemd-resolved'

execute "map udp port 53 to 8600" do
  user "root"
  group "root"
  command "iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600"
end

execute "map tcp port 53 to 8600" do
  user "root"
  group "root"
  command "iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600"
end

execute "save iptables rules" do
  user "root"
  group "root"
  command "iptables-save"
end

execute "install iptables-persistent" do
  user "root"
  group "root"
  command "DEBIAN_FRONTEND=noninteractive apt install -y -q iptables-persistent"
end