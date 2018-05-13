#
# Cookbook:: kafka-cookbook
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'kafka-cookbook'

# User and group of kafka process
default[cookbook_name]['kafka']['user'] = 'kafka'
default[cookbook_name]['kafka']['group'] = 'kafka'

