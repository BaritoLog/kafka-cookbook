property :name, String, name_property: true
property :systemd_unit, Hash, required: true
property :bin, String, required: true
property :prefix_log, String, required: true
property :log_file_name, String, required: true

action :create do
  # Configure systemd unit with options
  systemd_unit = new_resource.systemd_unit.to_hash

  # Create log directory
  directory "#{cookbook_name}:#{new_resource.prefix_log}" do
    path new_resource.prefix_log
    mode '0755'
    recursive true
    action :create
  end

  # Build command stack
  # cmd_stack = []
  # cmd_stack << new_resource.bin
  # cmd_stack << ">> #{new_resource.prefix_log}/#{new_resource.log_file_name}"

  systemd_unit "#{new_resource.name}.service" do
    enabled true
    active true
    masked false
    static false
    content systemd_unit
    triggers_reload true
    action %i[create enable start]
  end
end

action :restart do
  systemd_unit "#{new_resource.name}.service" do
    action :restart
  end
end
