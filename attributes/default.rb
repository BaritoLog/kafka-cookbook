#
# Cookbook:: kafka-cookbook
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'kafka-cookbook'

# Zookeeper cluster configuration with cluster-search
# Role used by the search to find other nodes of the cluster
default[cookbook_name]['zookeeper']['role'] = 'zookeeper-cluster'
# Hosts of the cluster, deactivate search if not empty
default[cookbook_name]['zookeeper']['hosts'] = []
# Expected size of the cluster. Ignored if hosts is not empty
default[cookbook_name]['zookeeper']['size'] = 0

# Kafka cluster configuration with cluster-search
# Role used by the search to find other nodes of the cluster
default[cookbook_name]['kafka']['role'] = 'kafka-cluster'
# Hosts of the cluster, deactivate search if not empty
default[cookbook_name]['kafka']['hosts'] = []
# Expected size of the cluster. Ignored if hosts is not empty
default[cookbook_name]['kafka']['size'] = 0

# User and group of kafka process
default[cookbook_name]['kafka']['user'] = 'kafka'
default[cookbook_name]['kafka']['group'] = 'kafka'

