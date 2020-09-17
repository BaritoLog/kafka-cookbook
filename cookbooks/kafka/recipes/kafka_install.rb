#
# Cookbook:: kafka
# Recipe:: kafka_install
#
# Copyright:: 2018, BaritoLog.
#
#

package_retries = node[cookbook_name]['package_retries']

# Update apt packages
apt_update 'update'

# Java is needed by Kafka, can install it with package
java = node[cookbook_name]['java']
# java installation can be intentionally ignored by setting the whole key to ''
unless java.to_s.empty?
  java_package = java[node['platform']]

  if java_package.to_s.empty?
    Chef::Log.warn  "No java specified for the platform #{node['platform']}, "\
                    'java will not be installed'

    Chef::Log.warn  'Please specify a java package name if you want to '\
                    'install java using this cookbook.'
  else
    package java_package do
      retries package_retries unless package_retries.nil?
    end
  end
end

# Add confluent repository
confluent_version = node.attribute[cookbook_name]['confluent_version'].split('.')[0..1].join('.')

case node['platform_family']
when 'rhel'
  yum_repository 'confluent' do
    description "Confluent platform v#{confluent_version} repository"
    baseurl "http://packages.confluent.io/rpm/#{confluent_version}"
    gpgkey "http://packages.confluent.io/rpm/#{confluent_version}/archive.key"
    action :create
  end
when 'debian'
  apt_repository 'confluent' do
    uri "http://packages.confluent.io/deb/#{confluent_version}"
    components %w[stable main]
    arch 'amd64'
    distribution nil
    key "http://packages.confluent.io/deb/#{confluent_version}/archive.key"
  end
end

# Install kafka with configured scala version
scala_version = node.attribute[cookbook_name]['scala_version']

case node['platform_family']
when 'rhel'
  package "confluent-kafka-#{scala_version}" do
    retries package_retries unless package_retries.nil?
  end
when 'debian'
  apt_package "confluent-kafka-#{scala_version}"
end
