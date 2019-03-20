#
# Cookbook:: zookeeper
# Recipe:: user
#
# Copyright:: 2018, BaritoLog.
#
#

# Define zookeeper group
group node[cookbook_name]['group'] do
  system true
end

# Define zookeeper user
user node[cookbook_name]['user'] do
  comment 'zookeeper service account'
  group node[cookbook_name]['group']
  system true
  shell '/sbin/nologin'
end

