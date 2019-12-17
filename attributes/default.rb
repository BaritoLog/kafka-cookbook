#
# Cookbook:: kafka
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

cookbook_name = 'kafka'

# Attributes for registering these services to consul
default[cookbook_name]['consul']['config_dir'] = '/opt/consul/etc'
default[cookbook_name]['consul']['bin'] = '/opt/bin/consul'
default[cookbook_name]['cli_opts'] = {
  'config-dir' => default[cookbook_name]['consul']['config_dir'],
  'enable-script-checks' => nil,
}

# Hosts of the cluster
default[cookbook_name]['zookeeper']['hosts'] = []

# Hosts of the cluster
default[cookbook_name]['kafka']['hosts'] = []
default[cookbook_name]['kafka']['hosts_count'] = 1

# Yggdrasil configuration
default[cookbook_name]['yggdrasil']['enabled'] = false
default[cookbook_name]['yggdrasil']['config_dir'] = '/opt/yggdrasil'
default[cookbook_name]['yggdrasil']['configure_etc_hosts'] = false

# User and group of kafka process
default[cookbook_name]['kafka']['user'] = 'kafka'
default[cookbook_name]['kafka']['group'] = 'kafka'

# Java package to install by platform
default[cookbook_name]['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# Confluent & kafka version
default[cookbook_name]['confluent_version'] = '4.1.0'
default[cookbook_name]['scala_version'] = '2.11'

# Kafka configuration
# Always use a chroot in Zookeeper
default[cookbook_name]['kafka']['zk_chroot'] =
  "/#{node[cookbook_name]['kafka']['role']}"

# Kafka configuration, default provided by Kafka project
default[cookbook_name]['kafka']['port'] = 9092
default[cookbook_name]['kafka']['max_replication_factor'] = 3
default[cookbook_name]['kafka']['config'] = {
  'advertised.listeners' => "PLAINTEXT://#{node['ipaddress']}:#{node[cookbook_name]['kafka']['port']}",
  'broker.id' => -1,
  'port' => node[cookbook_name]['kafka']['port'],
  'num.network.threads' => 3,
  'num.io.threads' => 8,
  'socket.send.buffer.bytes' => 102_400,
  'socket.receive.buffer.bytes' => 102_400,
  'socket.request.max.bytes' => 104_857_600,
  'log.dirs' => '/var/lib/kafka',
  'num.partitions' => 1,
  'num.recovery.threads.per.data.dir' => 1,
  'log.retention.hours' => 168,
  'log.segment.bytes' => 1_073_741_824,
  'log.retention.check.interval.ms' => 300_000,
  'log.cleaner.enable' => false,
  'zookeeper.connect' => 'localhost:2181',
  'zookeeper.connection.timeout.ms' => 15_000,
  'zookeeper.session.timeout.ms' => 15_000
}

# Kafka log4j configuration
default[cookbook_name]['kafka']['log4j'] = {
  'kafka.logs.dir' => '/var/log/kafka',
  'log4j.rootLogger' => 'INFO, stdout ',
  'log4j.appender.stdout' => 'org.apache.log4j.ConsoleAppender',
  'log4j.appender.stdout.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.stdout.layout.ConversionPattern' => '[%d] %p %m (%c)%n',
  'log4j.appender.kafkaAppender' =>
    'org.apache.log4j.RollingFileAppender',
  'log4j.appender.kafkaAppender.File' => '${kafka.logs.dir}/server.log',
  'log4j.appender.kafkaAppender.MaxFileSize' => '50MB',
  'log4j.appender.kafkaAppender.MaxBackupIndex' => 10,
  'log4j.appender.kafkaAppender.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.kafkaAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.stateChangeAppender' =>
    'org.apache.log4j.RollingFileAppender',
  'log4j.appender.stateChangeAppender.File' =>
    '${kafka.logs.dir}/state-change.log',
  'log4j.appender.stateChangeAppender.MaxFileSize' => '50MB',
  'log4j.appender.stateChangeAppender.MaxBackupIndex' => 10,
  'log4j.appender.stateChangeAppender.layout' =>
    'org.apache.log4j.PatternLayout',
  'log4j.appender.stateChangeAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.requestAppender' =>
    'org.apache.log4j.RollingFileAppender',
  'log4j.appender.requestAppender.File' =>
    '${kafka.logs.dir}/kafka-request.log',
  'log4j.appender.requestAppender.MaxFileSize' => '50MB',
  'log4j.appender.requestAppender.MaxBackupIndex' => 10,
  'log4j.appender.requestAppender.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.requestAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.cleanerAppender' =>
    'org.apache.log4j.RollingFileAppender',
  'log4j.appender.cleanerAppender.File' => '${kafka.logs.dir}/log-cleaner.log',
  'log4j.appender.cleanerAppender.MaxFileSize' => '50MB',
  'log4j.appender.cleanerAppender.MaxBackupIndex' => 10,
  'log4j.appender.cleanerAppender.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.cleanerAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.controllerAppender' =>
    'org.apache.log4j.RollingFileAppender',
  'log4j.appender.controllerAppender.File' =>
    '${kafka.logs.dir}/controller.log',
  'log4j.appender.controllerAppender.MaxFileSize' => '50MB',
  'log4j.appender.controllerAppender.MaxBackupIndex' => 10,
  'log4j.appender.controllerAppender.layout' =>
    'org.apache.log4j.PatternLayout',
  'log4j.appender.controllerAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.logger.kafka' => 'INFO, kafkaAppender',
  'log4j.logger.kafka.network.RequestChannel$' => 'WARN, requestAppender',
  'log4j.additivity.kafka.network.RequestChannel$' => 'false',
  'log4j.logger.kafka.request.logger' => 'WARN, requestAppender',
  'log4j.additivity.kafka.request.logger' => 'false',
  'log4j.logger.kafka.controller' => 'TRACE, controllerAppender',
  'log4j.additivity.kafka.controller' => 'false',
  'log4j.logger.kafka.log.LogCleaner' => 'INFO, cleanerAppender',
  'log4j.additivity.kafka.log.LogCleaner' => 'false',
  'log4j.logger.state.change.logger' => 'TRACE, stateChangeAppender',
  'log4j.additivity.state.change.logger' => 'false'
}

# Systemd unit file path
default[cookbook_name]['unit_path'] = '/etc/systemd/system'
# Restart kafka service if a configuration file change
default[cookbook_name]['kafka']['auto_restart'] = 'true'

# CLI options which will be defined in Systemd unit
# Those options will be transformed:
# - all key value pair are merged to create a single command line
# - if value is 'nil' (string nil), the key is ignored (erase the option)
# - if value is empty, the value is ignored but the key is outputted
# - if key and value are defined, key=value is generated
# The reason for string 'nil' is because using true nil will not override
# a previously defined non-nil value.
default[cookbook_name]['kafka']['cli_opts'] = {
  '-Xms4g' => '',
  '-Xmx4g' => '',
  '-XX:+UseG1GC' => '',
  '-XX:MaxGCPauseMillis' => 20,
  '-XX:InitiatingHeapOccupancyPercent' => 35,
  '-Dcom.sun.management.jmxremote' => '',
  '-Dcom.sun.management.jmxremote.authenticate' => false,
  '-Dcom.sun.management.jmxremote.ssl' => false,
  '-Dcom.sun.management.jmxremote.port' => 8090,
  '-Djava.rmi.server.hostname' => node['fqdn']
}

# Kafka Systemd service unit, can include all JVM options in ExecStart
# by using cli_opts
# You can override java path and kafka options by overriding ExecStart values
default[cookbook_name]['kafka']['unit'] = {
  'Unit' => {
    'Description' => 'Kafka publish-subscribe messaging system',
    'After' => 'network.target',
    'StartLimitInterval' => 400,
    'StartLimitBurst' => 10
  },
  'Service' => {
    'User' => node[cookbook_name]['kafka']['user'],
    'Group' => node[cookbook_name]['kafka']['group'],
    'SyslogIdentifier' => 'kafka',
    'Restart' => 'always',
    'RestartSec' => 30,
    'ExecStart' => {
      'start' => '/usr/bin/java',
      'end' =>
        '-Dlog4j.configuration=file:/etc/kafka/log4j.properties '\
        '-cp /usr/share/java/kafka/* '\
        'kafka.Kafka /etc/kafka/server.properties'
    }
  },
  'Install' => {
    'WantedBy' => 'multi-user.target'
  }
}

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil

#
# Burrow
#
default[cookbook_name]['burrow']['service_name'] = 'burrow'

# Temp directory
default[cookbook_name]['burrow']['prefix_temp'] = '/var/cache/chef'
# Installation directory
default[cookbook_name]['burrow']['prefix_root'] = '/opt'
# Where to link binaries
default[cookbook_name]['burrow']['prefix_bin'] = '/opt/bin'
# Log file location
default[cookbook_name]['burrow']['prefix_log'] = '/var/log/burrow'

# User and group of burrow process
default[cookbook_name]['burrow']['user'] = 'burrow'
default[cookbook_name]['burrow']['group'] = 'burrow'

default[cookbook_name]['burrow']['version'] = 'v1.1.0'
burrow_version = node[cookbook_name]['burrow']['version']

# Where to get the binary
default[cookbook_name]['burrow']['tar'] = 'Burrow_1.1.0_linux_amd64.tar.gz'
burrow_tar = node[cookbook_name]['burrow']['tar']

default[cookbook_name]['burrow']['mirror'] =
  "https://github.com/linkedin/Burrow/releases/download/#{burrow_version}/#{burrow_tar}"

# Burrow configurations
default[cookbook_name]['burrow']['zookeeper_clusters']= []
default[cookbook_name]['burrow']['kafka_cluster'] = {}
default[cookbook_name]['burrow']['topic_refresh_interval']= 60
default[cookbook_name]['burrow']['offset_refresh_interval']= 30
default[cookbook_name]['burrow']['port']= 8000

# Burrow Systemd service unit
default[cookbook_name]['burrow']['init_command'] = '/opt/bin/burrow -config-dir /opt/burrow/config'
