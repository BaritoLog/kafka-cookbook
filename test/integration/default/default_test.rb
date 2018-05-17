# # encoding: utf-8

# Inspec test for recipe kafka::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe group('kafka') do
    it { should exist }
  end

  describe user('kafka')  do
    it { should exist }
  end
end

describe package('openjdk-8-jdk-headless') do
  it { should be_installed }
end

describe package('confluent-kafka-2.11') do
  it { should be_installed }
end

describe file('/etc/kafka/server.properties') do
  its('mode') { should cmp '0644' }
end

describe file('/etc/kafka/log4j.properties') do
  its('mode') { should cmp '0644' }
end

describe directory('/var/lib/kafka') do
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'kafka' }
  its('group') { should eq 'kafka' }
end

describe directory('/var/log/kafka') do
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'kafka' }
  its('group') { should eq 'kafka' }
end

describe systemd_service('kafka') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
