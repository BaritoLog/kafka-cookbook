property :service_name, String, name_property: true
property :init_command, String, required: true

action :create do
  template '/etc/systemd/system/burrow.service' do
    source 'burrow_service.erb'
    mode '0644'
    variables(init_command: new_resource.init_command)
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end

  execute 'systemctl daemon-reload' do
    action :nothing
  end

  service new_resource.service_name do
    provider Object.const_get 'Chef::Provider::Service::Systemd'
    supports status: true, start: true, stop: true, restart: true
    action [:start, :enable]
  end
end
