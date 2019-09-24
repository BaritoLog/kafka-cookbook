#
# Cookbook:: zookeeper
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'zookeeper'

# Hosts of the cluster
default[cookbook_name]['hosts'] = []
default[cookbook_name]['my_id'] = []

# Yggdrasil configuration
default[cookbook_name]['yggdrasil']['enabled'] = false
default[cookbook_name]['yggdrasil']['host'] = ''
default[cookbook_name]['yggdrasil']['port'] = '80'
default[cookbook_name]['yggdrasil']['api_version'] = 'v2'
default[cookbook_name]['yggdrasil']['token'] = ''
default[cookbook_name]['yggdrasil']['namespace'] = ''
default[cookbook_name]['yggdrasil']['overrides'] = ''
default[cookbook_name]['yggdrasil']['key_name'] = "#{cookbook_name}_config"
default[cookbook_name]['yggdrasil']['configure_etc_hosts'] = false

# User and group of zookeeper process
default[cookbook_name]['user'] = 'zookeeper'
default[cookbook_name]['group'] = 'zookeeper'

# Java package to install by platform
default[cookbook_name]['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# zookeeper version
default[cookbook_name]['version'] = '3.4.12'
version = node[cookbook_name]['version']
# package sha256 checksum
default[cookbook_name]['checksum'] =
  'c686f9319050565b58e642149cb9e4c9cc8c7207aacc2cb70c5c0672849594b9'

# Where to get the zip file
binary = "zookeeper-#{version}.tar.gz"
default[cookbook_name]['mirror'] =
  "http://archive.apache.org/dist/zookeeper/zookeeper-#{version}/#{binary}"

# Installation directory
default[cookbook_name]['prefix_root'] = '/opt'
# Where to link installation dir
default[cookbook_name]['prefix_home'] = '/opt'
# Where to link binaries
default[cookbook_name]['prefix_bin'] = '/opt/bin'

# Log directory, empty by default because everything goes to journald
default[cookbook_name]['log_dir'] = '/var/opt/zookeeper/log'

# Data directory
default[cookbook_name]['data_dir'] = '/var/opt/zookeeper/lib'

# Zookeeper configuration
default[cookbook_name]['config'] = {
  'clientPort' => 2181,
  'dataDir' => node[cookbook_name]['data_dir'],
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2
}

# log4j configuration
# only CONSOLE by default but you can easily add ROLLINGFILE or TRACEFILE
# rubocop:disable Style/FormatStringToken
default[cookbook_name]['log4j'] = {
  'log4j.rootLogger' => 'INFO, CONSOLE',
  'log4j.appender.CONSOLE' => 'org.apache.log4j.ConsoleAppender',
  'log4j.appender.CONSOLE.Threshold' => 'INFO',
  'log4j.appender.CONSOLE.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.CONSOLE.layout.ConversionPattern' =>
    '%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n',
  'log4j.appender.ROLLINGFILE' => 'org.apache.log4j.RollingFileAppender',
  'log4j.appender.ROLLINGFILE.Threshold' => 'INFO',
  'log4j.appender.ROLLINGFILE.File' =>
    "#{node[cookbook_name]['log_dir']}/zookeeper.log",
  'log4j.appender.ROLLINGFILE.MaxFileSize' => '10MB',
  'log4j.appender.ROLLINGFILE.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.ROLLINGFILE.layout.ConversionPattern' =>
    '%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n',
  'log4j.appender.TRACEFILE' => 'org.apache.log4j.FileAppender',
  'log4j.appender.TRACEFILE.Threshold' => 'TRACE',
  'log4j.appender.TRACEFILE.File' =>
    "#{node[cookbook_name]['log_dir']}/zookeeper_trace.log",
  'log4j.appender.TRACEFILE.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.TRACEFILE.layout.ConversionPattern' =>
    '%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L][%x] - %m%n'
}
# rubocop:enable Style/FormatStringToken

# Systemd unit file path
default[cookbook_name]['unit_path'] = '/etc/systemd/system'
# Restart Zookeeper service if a configuration file change
default[cookbook_name]['auto_restart'] = true

# JVM configuration
# {key => value} which gives "key=value" or just "key" if value is nil
default[cookbook_name]['jvm_opts'] = {
  '-Dcom.sun.management.jmxremote' => nil,
  '-Dcom.sun.management.jmxremote.authenticate' => false,
  '-Dcom.sun.management.jmxremote.ssl' => false,
  '-Dcom.sun.management.jmxremote.port' => 2191,
  '-Djava.rmi.server.hostname' => node['fqdn']
}

# Attributes for registering this service to consul
default[cookbook_name]['consul']['bin'] = '/opt/bin/consul'
default[cookbook_name]['consul']['config_dir'] = '/opt/consul/etc'
default['consul']['cli_opts'] = {
  'config-dir' => default[cookbook_name]['consul']['config_dir'],
  'enable-script-checks' => nil
}

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil
