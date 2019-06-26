#
# Cookbook:: core
# Recipe:: default
#
# Copyright:: 2019, Nathan Cerny
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

reboot 'now' do
  action :nothing
  reason 'Reboot to finish Configuration'
end

hab_install 'default' do
  license 'accept'
end

hab_sup 'default'

hab_svc 'ncerny/core' do
  topology 'standalone'
  strategy 'at-once'
  channel node['core']['channel']
end

include_recipe "#{cookbook_name}::#{node['platform_family']}"
