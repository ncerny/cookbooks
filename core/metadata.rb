name 'core'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'Apache-2.0'
description 'My core cookbook'
long_description 'My core cookbook'
version '0.4.1'
chef_version '>= 14' if respond_to?(:chef_version)

issues_url 'https://github.com/ncerny/cookbooks/issues'
source_url 'https://github.com/ncerny/cookbooks'

depends 'systemd'
depends 'chocolatey'
depends 'habitat'
