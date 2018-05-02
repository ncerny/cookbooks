#
# Cookbook:: cerny
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
  only_if { chroot? }
end

execute 'timedatectl set-ntp true' do
  only_if { chroot? }
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

service 'systemd-timesyncd' do
  if chroot?
    action :enable
  else
    action [:enable, :start]
  end
end

service 'systemd-networkd' do
  if chroot?
    action :enable
  else
    action [:enable, :start]
  end
end

# xfsprogs
%w(
  openssh
  sudo
).each do |pkg|
  package pkg
end
