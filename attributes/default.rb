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

# Kafka configuration
# Always use a chroot in Zookeeper
default[cookbook_name]['kafka']['zk_chroot'] =
  "/#{node[cookbook_name]['kafka']['role']}"

# Kafka configuration, default provided by Kafka project
default[cookbook_name]['kafka']['config'] = {
  'broker.id' => -1,
  'port' => 9092,
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
  'zookeeper.connection.timeout.ms' => 6_000
}

# Kafka log4j configuration
default[cookbook_name]['kafka']['log4j'] = {
  'kafka.logs.dir' => '/var/log/kafka',
  'log4j.rootLogger' => 'INFO, stdout ',
  'log4j.appender.stdout' => 'org.apache.log4j.ConsoleAppender',
  'log4j.appender.stdout.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.stdout.layout.ConversionPattern' => '[%d] %p %m (%c)%n',
  'log4j.appender.kafkaAppender' =>
    'org.apache.log4j.DailyRollingFileAppender',
  'log4j.appender.kafkaAppender.DatePattern' => "'.'yyyy-MM-dd-HH",
  'log4j.appender.kafkaAppender.File' => '${kafka.logs.dir}/server.log',
  'log4j.appender.kafkaAppender.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.kafkaAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.stateChangeAppender' =>
    'org.apache.log4j.DailyRollingFileAppender',
  'log4j.appender.stateChangeAppender.DatePattern' =>
    "'.'yyyy-MM-dd-HH",
  'log4j.appender.stateChangeAppender.File' =>
    '${kafka.logs.dir}/state-change.log',
  'log4j.appender.stateChangeAppender.layout' =>
    'org.apache.log4j.PatternLayout',
  'log4j.appender.stateChangeAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.requestAppender' =>
    'org.apache.log4j.DailyRollingFileAppender',
  'log4j.appender.requestAppender.DatePattern' => "'.'yyyy-MM-dd-HH",
  'log4j.appender.requestAppender.File' =>
    '${kafka.logs.dir}/kafka-request.log',
  'log4j.appender.requestAppender.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.requestAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.cleanerAppender' =>
    'org.apache.log4j.DailyRollingFileAppender',
  'log4j.appender.cleanerAppender.DatePattern' => "'.'yyyy-MM-dd-HH",
  'log4j.appender.cleanerAppender.File' => '${kafka.logs.dir}/log-cleaner.log',
  'log4j.appender.cleanerAppender.layout' => 'org.apache.log4j.PatternLayout',
  'log4j.appender.cleanerAppender.layout.ConversionPattern' =>
    '[%d] %p %m (%c)%n',
  'log4j.appender.controllerAppender' =>
    'org.apache.log4j.DailyRollingFileAppender',
  'log4j.appender.controllerAppender.DatePattern' => "'.'yyyy-MM-dd-HH",
  'log4j.appender.controllerAppender.File' =>
    '${kafka.logs.dir}/controller.log',
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

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose)
default[cookbook_name]['package_retries'] = nil
