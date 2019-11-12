#
# Cookbook:: prometheus
# Attributes:: alertmanager
#
# Copyright:: 2018, BaritoLog.

# Alertmanager directory
default["alertmanager"]["dir"] = "#{node["prometheus"]["dir"]}/alertmanager"
default["alertmanager"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["alertmanager"]["binary"] = "#{node["alertmanager"]["dir"]}/alertmanager"

# Alertmanager version
default["alertmanager"]["version"] = "0.18.0"
default["alertmanager"]["checksum"] = "5f17155d669a8d2243b0d179fa46e609e0566876afd0afb09311a8bc7987ab15"
default["alertmanager"]["binary_url"] = "https://github.com/prometheus/alertmanager/releases/download/v#{node["alertmanager"]["version"]}/alertmanager-#{node["alertmanager"]["version"]}.linux-amd64.tar.gz"

# Alertmanager flags
default["alertmanager"]["flags"]["config.file"] = "#{node["alertmanager"]["dir"]}/alertmanager.yml"

# Alertmanager configuration
default["alertmanager"]["config"]["resolve_timeout"] = "3m"
default["alertmanager"]["config"]["smtp_smarthost"] = "localhost:25"
default["alertmanager"]["config"]["smtp_from"] = "alertmanager@example.org"
default["alertmanager"]["config"]["smtp_auth_username"] = "alertmanager"
default["alertmanager"]["config"]["smtp_auth_password"] = "password"
default["alertmanager"]["config"]["hipchat_auth_token"] = "1234556789"
default["alertmanager"]["config"]["hipchat_api_url"] = "https://hipchat.foobar.org/"
default["alertmanager"]["config"]["route"] = []
default["alertmanager"]["config"]["inhibit_rules"] = []
default["alertmanager"]["config"]["receivers"] = []
default["alertmanager"]["config"]["templates"] = [
  File.join(node["alertmanager"]["dir"], "/templates/*.yml"),
]
