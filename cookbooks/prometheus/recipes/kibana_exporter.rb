#
# Cookbook:: prometheus
# Recipe:: kibana_exporter
#
# Copyright:: 2019, BaritoLog.

module Plugin
  def self.exists?(kibana_base_dir)
    cmd = Mixlib::ShellOut.new("bin/kibana-plugin list", cwd: kibana_base_dir)
    cmd.run_command
    cmd.stdout.include? "kibana-prometheus-exporter"
  end
end

execute 'plugin-install' do
  cwd node["kibana_exporter"]["kibana_base_dir"]
  command "NODE_OPTIONS='--max-old-space-size=4096' bin/kibana-plugin install #{node["kibana_exporter"]["url"]}"
  timeout 600
  ignore_failure true
  not_if {
    Plugin.exists?(node["kibana_exporter"]["kibana_base_dir"])
  }
end