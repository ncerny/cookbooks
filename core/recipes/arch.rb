#
# Cookbook:: core
# Recipe:: arch
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

link '/etc/localtime' do
  to '/usr/share/zoneinfo/US/Central'
  link_type :symbolic
end

execute 'hwclock --systohc' do
  only_if { chroot? }
end

execute 'timedatectl set-local-rtc 0' do
  ignore_failure true
  not_if { chroot? }
end

execute 'timedatectl set-ntp true' do
  not_if { chroot? }
end

file '/etc/locale.gen' do
  content 'en_US.UTF-8 UTF-8'
  notifies :run, 'execute[locale-gen]', :immediately
end

execute 'locale-gen' do
  action :nothing
end

file '/etc/locale.conf' do
  content 'LANG=en_US.UTF-8'
end

# System
cookbook_file '/etc/pacman.conf' do
  source 'pacman-conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[Install and Enable Yaourt Package Tool]', :immediately
end

execute 'Install and Enable Yaourt Package Tool' do
  action :nothing
  command 'pacman -Sy --noconfirm yaourt'
  not_if 'which yaourt'
end

execute 'Update AUR Repositories' do
  command 'yaourt -Syu --noconfirm'
  not_if { node['yaourt_last_refresh'] && (DateTime.now - DateTime.parse(node['yaourt_last_refresh'])) < 84601 }
  notifies :run, 'ruby_block[update-yaourt-refresh-time]', :immediately
  notifies :run, 'execute[grub-bios-install]', :delayed
end

ruby_block 'update-yaourt-refresh-time' do
  action :nothing
  block do
    node.normal['yaourt_last_refresh'] = DateTime.now.to_s
  end
end

package 'reflector'

execute 'reflector' do
  command 'reflector --country "United States" --latest 200 --age 24 --sort rate --save /etc/pacman.d/mirrorlist'
  not_if { node['reflector_last_refresh'] && (DateTime.now - DateTime.parse(node['reflector_last_refresh'])) < 84601 }
  notifies :run, 'ruby_block[update-reflector-refresh-time]', :immediately
end

ruby_block 'update-reflector-refresh-time' do
  action :nothing
  block do
    node.normal['reflector_last_refresh'] = DateTime.now.to_s
  end
end

package 'intel-ucode' do
  only_if { cpu_type.eql?('GenuineIntel') }
end

directory '/etc/pacman.d/hooks/'

include_recipe "#{cookbook_name}::_boot-grub"

# xfsprogs
%w(
  openssh
  sudo
).each do |pkg|
  package pkg
end

systemd_network '10-bond0' do
  match_driver %w(bnx2 igb e1000*)
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
end if node['network']['interfaces']['bond0']

service 'systemd-timesyncd' do
  action [:enable, :start]
end

service 'systemd-networkd' do
  action [:enable, :start]
end

reboot 'Reboot into Arch Linux install' do
  action :request_reboot
  reason 'Need to reboot into Arch Linux'
  only_if { chroot? }
end
