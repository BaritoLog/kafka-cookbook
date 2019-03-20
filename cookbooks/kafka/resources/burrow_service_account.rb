property :user, String, name_property: true
property :group, String, required: true

action :create do
  group new_resource.group do
    system true
  end

  user new_resource.user do
    comment "#{new_resource.user} service account"
    group new_resource.group
    system true
    shell '/sbin/nologin'
  end
end
