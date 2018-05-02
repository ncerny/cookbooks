#
# Cookbook:: cerny
# Recipe:: server
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

include_recipe "#{cookbook_name}::#{node['platform_family']}"

systemd_network '10-bond0' do
  match_driver %w(bnx2 igb e1000e)
  network_bond 'bond0'
end

systemd_network '10-bond1' do
  match_driver %w(mlx4* ixgbe)
  network_bond 'bond1'
  link_mtu_bytes '9000'
end

systemd_network '20-bond0' do
  match_name 'bond0'
  network_dhcp true
  network_i_pv6_accept_ra true
  network_i_pv6_privacy_extensions 'prefer-public'
end

node['network']['interfaces']['bond0']['addresses'].each do |k, v|
  next unless v['family'].eql?(inet)
  systemd_network '20-bond1' do
    match_name 'bond1'
    network_dhcp false
    network_address k.sub('192.168', '172.16')
    link_mtu_bytes '9000'
    network_i_pv6_accept_ra true
    network_i_pv6_privacy_extensions 'yes'
  end
end
