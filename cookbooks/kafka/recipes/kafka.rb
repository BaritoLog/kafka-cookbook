#
# Cookbook:: kafka
# Recipe:: kafka
#
# Copyright:: 2018, BaritoLog.
#
#

include_recipe "#{cookbook_name}::kafka_search"
include_recipe "#{cookbook_name}::kafka_user"
include_recipe "#{cookbook_name}::kafka_install"
include_recipe "#{cookbook_name}::kafka_config"
include_recipe "#{cookbook_name}::kafka_systemd"
