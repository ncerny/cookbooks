#
# Cookbook:: workstation
# Recipe:: hab
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

group 'hab' do
  gid 1234
end

user 'hab' do
  uid 1234
  gid 1234
  system true
  home '/hab'
end

systemd_service 'hab-sup' do
  action [:create, :enable]
  unit_description 'The Habitat Supervisor'
  service do
    exec_start '/bin/hab sup run --auto-update'
  end
  install_wanted_by 'multi-user.target'
end
