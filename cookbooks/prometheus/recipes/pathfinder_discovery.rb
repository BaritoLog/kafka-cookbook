#
# Cookbook:: prometheus
# Recipe:: pathfinder_discovery
#
# Copyright:: 2019, BaritoLog.

include_recipe "prometheus::user"

apt_repository 'brightbox-ruby' do
  uri 'ppa:brightbox/ruby-ng'
end

if Chef::VERSION.split('.')[0].to_i > 12
  apt_update
else
  apt_update 'apt update' do
    action :update
  end
end

package %w(software-properties-common ruby2.5 ruby2.5-dev nodejs build-essential patch zlib1g-dev liblzma-dev libffi-dev libcurl4-openssl-dev)

gem_package 'bundler'

package 'jq'

# Create directory
directory node["pathfinder_discovery"]["dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

directory node["pathfinder_discovery"]["log_dir"] do
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0755"
  recursive true
end

#create file based on template
template "#{node["pathfinder_discovery"]["dir"]}/container_parser.rb" do
  source "pathfinder_discovery_container.erb"
  owner node["prometheus"]["user"]
  group node["prometheus"]["group"]
  mode "0644"
end

#create cron
node["pathfinder_discovery"]["pathfinder_cluster"].each do |cluster_name| 
  node["pathfinder_discovery"]["pathfinder_scrape_type"].each do |key,value| 
    path = key == 'container' ?  node["pathfinder_discovery"]["pathfinder_containers_path"] : node["pathfinder_discovery"]["pathfinder_nodes_path"]
    cron "scheduling-pathfinder-#{cluster_name}-#{key}" do
      minute '*/5'
      user node["prometheus"]["user"]
      command "curl -s '#{node["pathfinder_discovery"]["pathfinder_url"]}#{path}?cluster_name=#{cluster_name}' -H 'X-Auth-Token: #{node["pathfinder_discovery"]["pathfinder_token"]}' | ruby #{node["pathfinder_discovery"]["dir"]}/container_parser.rb | jq '.' > #{node["pathfinder_discovery"]["dir"]}/#{cluster_name}_#{value}"
    end
  end
end

