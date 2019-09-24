## Yggdrasil Support
Enabling yggdrasil support fill make this cookbook fetch config from yggdrasil, there some attribute related to yggdrasil support:
```ruby
cookbook_name = 'zookeeper'
default[cookbook_name]['yggdrasil']['enabled'] = false
default[cookbook_name]['yggdrasil']['host'] = ''
default[cookbook_name]['yggdrasil']['port'] = '80'
default[cookbook_name]['yggdrasil']['api_version'] = 'v2'
default[cookbook_name]['yggdrasil']['token'] = ''
default[cookbook_name]['yggdrasil']['namespace'] = ''
default[cookbook_name]['yggdrasil']['overrides'] = ''
default[cookbook_name]['yggdrasil']['key_name'] = "#{cookbook_name}_config"
default[cookbook_name]['yggdrasil']['configure_etc_hosts'] = false
```
Yggdrasil config will fetched based on it namespace, overrides (tag), and key name. The value must in JSON format:
```json
[
   {
		"hostname": "<zoo_hostname>",
		"ip": "[zoo_ip]"
	},
	{
		"hostname": "<zoo_hostname>",
		"ip": "[zoo_ip]"
	},
	{
		"hostname": "<zoo_hostname>",
		"ip": "[zoo_ip]"
	}
]
```
Yggdrasil support will also configure box `/etc/hosts` if attribute `configure_etc_hosts` is true. This option is usable if your zookeeper node does not have reachable domain/hostname.   
