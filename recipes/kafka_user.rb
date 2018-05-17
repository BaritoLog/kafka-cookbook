#
# Cookbook:: kafka
# Recipe:: kafka_user
#
# Copyright:: 2018, BaritoLog.
#
#

# Define kafka group
group node[cookbook_name]['kafka']['group'] do
  system true
end

# Define kafka user
user node[cookbook_name]['kafka']['user'] do
  comment 'kafka service account'
  group node[cookbook_name]['kafka']['group']
  system true
  shell '/sbin/nologin'
end

