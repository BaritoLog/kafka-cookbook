#
# Cookbook:: consul
# Recipe:: default
#
# Copyright:: 2018, BaritoLog.
#
#

include_recipe "#{cookbook_name}::search"
include_recipe "#{cookbook_name}::user"
include_recipe "#{cookbook_name}::install"
include_recipe "#{cookbook_name}::config"
include_recipe "#{cookbook_name}::systemd"
include_recipe "#{cookbook_name}::dns_setup"
