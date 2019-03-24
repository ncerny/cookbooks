name 'workstation'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'Apache-2.0'
description 'Cookbook for installing and configuring my workstation.'
long_description 'Cookbook for installing and configuring my workstation.'
version '0.13.0'
chef_version '>= 14.0' if respond_to?(:chef_version)
issues_url 'https://github.com/ncerny/cookbooks/issues'
source_url 'https://github.com/ncerny/cookbooks'

depends 'systemd'
