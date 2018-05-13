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

# Java package to install by platform
default[cookbook_name]['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-8-jdk-headless'
}

# Confluent & kafka version
default[cookbook_name]['confluent_version'] = '4.1.0'
default[cookbook_name]['scala_version'] = '2.11'

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil
