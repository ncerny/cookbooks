#
# Cookbook:: core
# Recipe:: _boot-grub
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

cookbook_file '/etc/pacman.d/hooks/grub.hook' do
  source 'grub.hook'
  owner 'root'
  group 'root'
  mode '0644'
end

package 'efibootmgr' do
  only_if { ::File.exist?('/sys/firmware/efi/efivars') }
end

package 'grub' do
  notifies :run, 'execute[grub-bios-install]', :immediately
  notifies :run, 'execute[grub-uefi-install]', :immediately
end

execute 'grub-bios-install' do
  action :nothing
  command 'grub-install --target=i386-pc /dev/sda'
  # not_if { ::File.exist?('/sys/firmware/efi/efivars') }
end

execute 'grub-uefi-install' do
  action :nothing
  command 'grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=archlinux'
  only_if { ::File.exist?('/sys/firmware/efi/efivars') }
end
