# Provide NSSM helper methods
module NSSM
  extend ::Chef::Mixin::ShellOut

  module_function

  def binary_path(node)
    binary_name = ::File.basename(node['nssm']['src']).gsub(/\.zip$/, '.exe')
    "#{node['nssm']['install_location']}\\#{binary_name}"
  end

  # Properly format a NSSM command
  def command(binary, action, service, param = nil, sub_param = nil)
    [
      prepare_parameter(binary),
      action, # simple keyword does not need transformation
      prepare_parameter(service),
      prepare_parameter(param),
      prepare_parameter(sub_param, false) # last param does no need quoting
    ].reject(&:empty?).join ' '
  end

  # Cleanup string read from nssm dump
  def strip_and_unescape(value)
    value.strip
         .gsub(/^\^"(.*)\^"$/, '\1')
         .gsub(/^"(.*)"$/, '\1')
         .gsub(/\^([\\"&%^<>|])/, '\1')
         .gsub(/\\\\/, '\\')
  end

  # Cleanup string that'll be set as nssm parameter
  # Optionnally add quotes around given value if necessary
  def prepare_parameter(value, quote = true)
    result = value.to_s.dup.strip.gsub('"', '\"')
    if quote && result =~ /[ *]/
      value.gsub(/^(.*)$/, "\"#{result}\"")
    else
      result
    end
  end

  def dump_parameters(binary, service)
    ::Mash.new.tap do |result|
      shell_out(command(binary, :dump, service)).stdout.each_line do |line|
        case line
        when /install #{service} (.*)/
          result['Application'] = strip_and_unescape(::Regexp.last_match(1))
        when /set #{service} (.*)/
          key, value = strip_and_unescape(::Regexp.last_match(1)).split(' ', 2)
          result[key] = value
        end
      end
    end
  end
end
