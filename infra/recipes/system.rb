#
# Cookbook:: cerny-cc
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
    exec_start_pre '/usr/bin/curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=6&use_mirror_status=on" -o /etc/pacman.d/mirrorlist.new'
    exec_start_pre '/usr/bin/sed -i -e "s/^#Server/Server/" -e "/^#/d" /etc/pacman.d/mirrorlist.new'
    exec_start '/usr/bin/rankmirrors -n 5 /etc/pacman.d/mirrorlist.new > /etc/pacman.d/mirrorlist'
    exec_start_post '/usr/bin/rm /etc/pacman.d/mirrorlist.new'
  end
end

systemd_timer 'pacman-update-mirrors' do
  action [:create, :enable, :start]
  timer_on_calendar '*-*-* 02:00:00'
end

systemd_service 'sync-pacman' do
  action [:create]
  service do
    type 'oneshot'
    exec_start '/usr/bin/pacman -Syu'
  end
end

systemd_timer 'sync-pacman' do
  action [:create, :enable, :start]
  timer_on_calendar '*-*-* 04:00:00'
end
