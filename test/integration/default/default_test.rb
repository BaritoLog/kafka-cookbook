# # encoding: utf-8

# Inspec test for recipe kafka::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

require 'rspec/retry'

unless os.windows?
  describe group('kafka') do
    it { should exist }
  end

  describe user('kafka')  do
    it { should exist }
  end
end

describe package('openjdk-11-jdk-headless') do
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

# Check if kafka is connected with zookeeper
describe 'Connection kafka - zookeeper' do
  it 'should be connected' do
    expect(command('zookeeper-shell localhost:2181 <<< "ls /kafka-cluster/brokers/ids"').stdout).to match /1001|\[\]/
  end
end

describe file('/etc/hosts') do
  its('content') { should match /0.0.0.0\s+default-opscode-ubuntu-1804-chef-14/ }
end

describe directory('/opt/burrow') do
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'burrow' }
  its('group') { should eq 'burrow' }
end

describe directory('/opt/burrow/config') do
  its('mode') { should cmp '0755' }
  its('owner') { should eq 'burrow' }
  its('group') { should eq 'burrow' }
end

describe file('/opt/burrow/config/burrow.toml') do
  its('mode') { should cmp '0644' }
  its('owner') { should eq 'burrow' }
  its('group') { should eq 'burrow' }

  # Should check if yggdrasil configs are persisted
  its('content') { should match /servers=\["default-opscode-ubuntu-1804-chef-14:2181"\]/ }
end

describe systemd_service('burrow') do
  it { should be_installed }
  it { should be_enabled }

  # Test is replaced because the test before only checks before the block starts
  it 'should be running', retry: 3, retry_wait: 10 do
    expect(command("sudo systemctl is-active burrow --quiet").exit_status).to eq 0
  end
end

describe systemd_service('consul') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }

end

describe package('netcat') do
  it { should be_installed }
end
