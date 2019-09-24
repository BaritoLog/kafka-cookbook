name 'consul'
maintainer 'BaritoLog'
maintainer_email 'you@example.com'
license 'MIT'
description 'Installs/Configures consul cluster'
long_description 'Installs/Configures consul cluster'
version '1.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/BaritoLog/consul-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/BaritoLog/consul-cookbook'

depends 'ark'
