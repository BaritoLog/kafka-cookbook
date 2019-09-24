#
# Cookbook:: consul
# Recipe:: search 
#
# Copyright:: 2018, BaritoLog.

# Don't continue if these variables are empty
return if node[cookbook_name]['hosts'].empty?

# Keep it simple for now
node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['hosts'] = node[cookbook_name]['hosts']
