## Yggdrasil Support
Enabling yggdrasil support makes this cookbook fetch zookeeper config from yggdrasil, these are some attributes related to yggdrasil support:
```ruby
default[cookbook_name]['yggdrasil']['enabled'] = false
default[cookbook_name]['yggdrasil']['host'] = ''
default[cookbook_name]['yggdrasil']['port'] = '80'
default[cookbook_name]['yggdrasil']['api_version'] = 'v2'
default[cookbook_name]['yggdrasil']['token'] = ''
default[cookbook_name]['yggdrasil']['namespace'] = ''
default[cookbook_name]['yggdrasil']['overrides'] = ''
default[cookbook_name]['yggdrasil']['key_name'] = "zookeeper_config"
default[cookbook_name]['yggdrasil']['configure_etc_hosts'] = false
```
Yggdrasil config will fetch based on the namespace, overrides (tag), and key name. The value must be in JSON format:
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
Yggdrasil support will also configure box `/etc/hosts` if `configure_etc_hosts` attribute is true. This option is usable if your zookeeper node does not have reachable domain/hostname.
