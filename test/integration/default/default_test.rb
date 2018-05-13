# # encoding: utf-8

# Inspec test for recipe kafka-cookbook::default

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

