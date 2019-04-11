#
# Cookbook:: workstation
# Recipe:: system
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

systemd_swap 'dev-sda3' do
  action [:create, :enable, :start]
  swap_what '/dev/sda3'
  install_wanted_by 'multi-user.target'
end

sysctl 'vm.swappiness' do
  value 10
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

package 'pacman-contrib'

systemd_service 'pacman-update-mirrors' do
  action [:create]
  service do
    type 'oneshot'
    exec_start '/usr/bin/curl -s -o /etc/pacman.d/mirrorlist_full "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=6&use_mirror_status=on"'
    exec_start_post '/usr/bin/sed -i -e "s/^#Server/Server/" /etc/pacman.d/mirrorlist_full'
  end
end

systemd_timer 'pacman-update-mirrors' do
  action [:create, :enable, :start]
  timer_on_calendar 'Sun *-*-* 02:00:00'
  install_wanted_by 'multi-user.target'
end

systemd_service 'pacman-rank-mirror' do
  action :create
  service do
    type 'oneshot'
    exec_start '/bin/sh -c "/usr/bin/rankmirrors /etc/pacman.d/mirrorlist_full > /etc/pacman.d/mirrorlist"'
  end
end

systemd_path 'pacman-rank-mirror' do
  action [:create, :enable, :start]
  path_path_changed '/etc/pacman.d/mirrorlist_full'
  install_wanted_by 'multi-user.target'
end

systemd_service 'sync-pacman' do
  action [:create]
  service do
    type 'oneshot'
    exec_start '/usr/bin/pacman -Syu --noconfirm'
  end
end

systemd_timer 'sync-pacman' do
  action [:create, :enable, :start]
  timer_on_calendar '*-*-* 04:00:00'
  install_wanted_by 'multi-user.target'
end
