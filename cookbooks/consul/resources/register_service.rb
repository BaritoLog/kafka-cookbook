property :name,       String, name_property: true
property :config,     Hash,   default: {}
property :checks,     Array,  default:[] 
property :config_dir, String, required: true
property :user,       String, default: 'consul'
property :group,      String, default: 'consul'
property :consul_bin, String, required: true

default_action :run

action :run do
  # Create service configuration file
  config = { "service" => new_resource.config, "checks" => new_resource.checks }

  file "#{new_resource.config_dir}/#{new_resource.name}.json" do
    content Chef::JSONCompat.to_json_pretty(config)
    owner new_resource.user
    group new_resource.group
    mode '0640'
  end

  execute "reload consul" do
    command "sleep 5; #{new_resource.consul_bin} reload"
  end
end
