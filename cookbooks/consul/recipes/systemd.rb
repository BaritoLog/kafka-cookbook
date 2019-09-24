#
# Cookbook:: consul
# Recipe:: systemd 
#
# Copyright:: 2018, BaritoLog.

# Return if servers have not been configured
return if node.run_state.dig(cookbook_name, 'hosts').nil?

# Construct command line options
options = node[cookbook_name]['cli_opts'].map do |key, opt|
  "-#{key.to_s.tr('_', '-')}#{" #{opt}" unless opt.nil?}"
end.join(' ')

# Configure systemd unit with options
unit = node[cookbook_name]['systemd_unit'].to_hash
bin = "#{node[cookbook_name]['prefix_home']}/consul/consul"
unit['Service']['ExecStart'] = "#{bin} agent #{options}"

systemd_unit 'consul.service' do
  enabled true
  active true
  masked false
  static false
  content unit
  triggers_reload true
  action %i[create enable start restart]
end

