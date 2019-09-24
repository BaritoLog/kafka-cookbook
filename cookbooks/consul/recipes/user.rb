#
# Cookbook:: consul
# Recipe:: user
#
# Copyright:: 2018, BaritoLog.
#
#

# Define consul group
group node[cookbook_name]['group'] do
  system true
end

# Define consul user
user node[cookbook_name]['user'] do
  comment 'consul service account'
  group node[cookbook_name]['group']
  system true
  shell '/sbin/nologin'
end

