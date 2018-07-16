#
# Cookbook:: cerny-cc
# Recipe:: time
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

systemd_service 'sync-hwclock' do
  action :create
  unit_description 'Sync the Hardware Clock'
  service do
    type 'oneshot'
    exec_start '/usr/bin/hwclock --systohc'
  end
end

systemd_timer 'sync-hwclock' do
  action [:create, :enable, :start]
  timer do
    on_unit_active_sec '30 days'
    on_boot_sec '30 seconds'
  end
  install_wanted_by 'multi-user.target'
end

service 'systemd-timesyncd' do
  action [:enable, :start]
end
