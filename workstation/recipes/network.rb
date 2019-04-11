#
# Cookbook:: workstation
# Recipe:: network
#
# Copyright:: 2018, Nathan Cerny
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

%w(enp0s25 enp3s0 enp10s0 wlp8s0).each do |network|
  systemd_network network do
    action :delete
    notifies :restart, 'service[systemd-networkd]'
  end
end

systemd_network 'home' do
  match_name 'enp0*'
  network_dhcp true
  notifies :restart, 'service[systemd-networkd]'
end

systemd_network 'wifi' do
  match_name 'wlp*'
  notifies :restart, 'service[systemd-networkd]'
end

systemd_network 'infra' do
  match_name ['enp2s*','enp3s*','enp10s*']
  network_dhcp true
  notifies :restart, 'service[systemd-networkd]'
end

service 'systemd-resolved' do
  action [:enable, :start]
end

service 'NetworkManager' do
  action [:disable, :stop]
  notifies :restart, 'service[systemd-networkd]', :immediately
end

file '/etc/resolv.conf' do
  action :delete
  not_if { ::File.symlink?('/etc/resolv.conf') }
end

link '/etc/resolv.conf' do
  to '/run/systemd/resolve/resolv.conf'
end

service 'systemd-networkd' do
  action :enable
end
