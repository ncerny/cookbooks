#
# Cookbook:: cerny-cc
# Recipe:: boot
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

package 'intel-ucode' do
  only_if { cpu_type.eql?('GenuineIntel') }
end

directory '/etc/pacman.d/hooks'

file '/etc/pacman.d/hooks/systemd-boot.hook' do
  content <<-EOF
    [Trigger]
    Type = Package
    Operation = Upgrade
    Target = systemd

    [Action]
    Description = Updating systemd-boot
    When = PostTransaction
    Exec = /usr/bin/bootctl update
  EOF
end

cookbook_file '/boot/loader/loader.conf' do
  source 'boot-loader.conf'
end

template '/boot/loader/entries/arch.conf' do
  source 'arch.conf.erb'
  variables options: 'root=LABEL=arch_os rw add_efi_memmap'
end
