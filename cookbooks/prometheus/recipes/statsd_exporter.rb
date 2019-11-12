#
# Cookbook:: prometheus
# Recipe:: statsd_exporter
#
# Copyright:: 2018, BaritoLog.

include_recipe "prometheus::user"

# Create directory
directory node["statsd_exporter"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["statsd_exporter"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

config = {
  "defaults" => {
    "timer_type" => node["statsd_exporter"]["config"]["timer_type"],
    "buckets" => node["statsd_exporter"]["config"]["buckets"],
    "match_type" => node["statsd_exporter"]["config"]["match_type"],
    "glob_disable_ordering" => node["statsd_exporter"]["config"]["glob_disable_ordering"],
  },
  "defaults" => node["statsd_exporter"]["config"]["defaults"],
  "mappings" => node["statsd_exporter"]["config"]["mappings"],
}

file "statsd_exporter config" do
  path node["statsd_exporter"]["flags"]["statsd.mapping-config"]
  content hash_to_yaml(config)
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0644"
  notifies :restart, "service[statsd_exporter]"
end

# Download prometheus statsd_exporter binary & unpack
ark ::File.basename(node["statsd_exporter"]["dir"]) do
  url node["statsd_exporter"]["binary_url"]
  checksum node["statsd_exporter"]["checksum"]
  version node["statsd_exporter"]["version"]
  prefix_root Chef::Config["file_cache_path"]
  path ::File.dirname(node["statsd_exporter"]["dir"])
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  action :put
  notifies :restart, "service[statsd_exporter]", :delayed
end

systemd_unit "statsd_exporter.service" do
  content <<~END_UNIT
            [Unit]
            Description=Prometheus Statsd Exporter
            After=network.target

            [Service]
            ExecStart=/bin/bash -ce 'exec #{node["statsd_exporter"]["binary"]} #{Gitlab::Prometheus.kingpin_flags_for(node, "statsd_exporter")} >> "#{node["statsd_exporter"]["log_dir"]}/statsd_exporter.log" 2>&1'
            User=#{node["prometheus"]["user"]}
            Restart=always

            [Install]
            WantedBy=multi-user.target
          END_UNIT
  action %i(create enable)
  notifies :restart, "service[statsd_exporter]", :delayed
end

service "statsd_exporter" do
  action %i(enable start)
end
