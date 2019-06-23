#
# Cookbook:: core
# Recipe:: _systemd-boot
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

return unless ::File.exist?('/sys/firmware/efi/efivars')

execute 'Install systemd-boot' do
  command 'bootctl --path=/boot install'
end

cookbook_file '/etc/pacman.d/hooks/systemd-boot.hook' do
  source 'systemd-boot.hook'
  owner 'root'
  group 'root'
  mode '0644'
end
