#
# Cookbook:: kafka-cookbook
# Recipe:: kafka
#
# Copyright:: 2018, BaritoLog.
#
#

include_recipe "#{cookbook_name}::kafka_search"
include_recipe "#{cookbook_name}::kafka_user"
