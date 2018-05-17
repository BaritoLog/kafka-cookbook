#
# Cookbook:: kafka
# Recipe:: kafka_systemd 
#
# Copyright:: 2018, BaritoLog.

# Configuration files to be subscribed
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['kafka'] ||= {}
conf_files = node.run_state[cookbook_name]['kafka']['conf_files']
template_files = (conf_files || {}).map { |path| "template[#{path}]" }

# return if something was interrupted (config probably)
return if node.run_state[cookbook_name]['kafka']['interrupted']

# Configure systemd unit with options
unit = node[cookbook_name]['kafka']['unit'].to_hash
unit['Service']['ExecStart'] = [
  unit['Service']['ExecStart']['start'],
  node[cookbook_name]['kafka']['cli_opts'].map do |key, opt|
    # remove key if value is string 'nil' (using 'string' is not a bug)
    "#{key}#{"=#{opt}" unless opt.to_s.empty?}" unless opt == 'nil'
  end,
  unit['Service']['ExecStart']['end']
].flatten.compact.join(" \\\n  ")

# Create unit
auto_restart = node[cookbook_name]['kafka']['auto_restart']
systemd_unit "kafka.service" do
  enabled true
  active true
  masked false
  static false
  content unit
  triggers_reload true
  action %i[create enable start]
  subscribes :restart, template_files if auto_restart
end
