#
# Cookbook:: zookeeper
# Recipe:: search 
#
# Copyright:: 2018, BaritoLog.

# Don't continue if these variables are empty
node.run_state[cookbook_name] ||= {}
if node[cookbook_name]['hosts'].empty? || !node[cookbook_name]['my_id'].is_a?(Integer)
  node.run_state[cookbook_name]['abort?'] = true
  return
end

# Keep it simple for now
node.run_state[cookbook_name]['hosts'] = node[cookbook_name]['hosts']
node.run_state[cookbook_name]['my_id'] = node[cookbook_name]['my_id']
