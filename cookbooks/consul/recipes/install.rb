#
# Cookbook:: consul
# Recipe:: install 
#
# Copyright:: 2018, BaritoLog.
#
#

package_retries = node[cookbook_name]['package_retries']

apt_update

# unzip & rsync may not be installed by default
package %w[unzip rsync] do
  retries package_retries unless package_retries.nil?
end

# Create prefix directories
[
  node[cookbook_name]['prefix_root'],
  node[cookbook_name]['prefix_home'],
  node[cookbook_name]['prefix_bin']
].uniq.each do |dir_path|
  directory "#{cookbook_name}:#{dir_path}" do
    path dir_path
    mode '0755'
    recursive true
    action :create
  end
end

# Install consul binaries
ark 'consul' do
  action :install
  url node[cookbook_name]['mirror']
  version node[cookbook_name]['version']
  checksum node[cookbook_name]['checksum']
  prefix_root node[cookbook_name]['prefix_root']
  prefix_home node[cookbook_name]['prefix_home']
  prefix_bin node[cookbook_name]['prefix_bin']
  has_binaries ['consul']
  strip_components 0
  owner node[cookbook_name]['user']
  group node[cookbook_name]['group']
end

execute 'apt autoremove' do
  command 'apt autoremove -y'
end
