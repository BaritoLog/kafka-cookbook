name 'kafka'
maintainer 'BaritoLog'
maintainer_email 'you@example.com'
license 'MIT'
description 'Installs/Configures kafka cluster'
long_description 'Installs/Configures kafka cluster'
version '2.11'
chef_version '>= 12.14' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/BaritoLog/kafka-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/BaritoLog/kafka-cookbook'

depends 'hostsfile'
depends 'zookeeper'
