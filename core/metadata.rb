name 'core'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures cerny core infrastructure'
long_description 'Installs/Configures cerny core infrastructure'
version '0.3.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

issues_url 'https://github.com/ncerny/cookbooks/issues'
source_url 'https://github.com/ncerny/cookbooks'

depends 'audit'
depends 'systemd'
depends 'chef_client_updater'
depends 'chef-client'
