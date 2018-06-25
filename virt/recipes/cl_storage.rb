#
# Cookbook:: cerny-cc
# Recipe:: cl_storage
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

package 'glusterfs'

systemd_mount 'export-data' do
  action [:create, :enable, :start]
  mount_what 'LABEL=data'
  install_wanted_by 'default.target'
end

log 'Please manually create Gluster Volume' do
  not_if 'gluster volume info gv0'
end

systemd_mount 'mnt-gv0' do
  action [:create, :enable, :start]
  mount_what "#{node['hostname']}:/gv0"
  mount_type 'glusterfs'
  only_if 'gluster volume info gv0'
  install_wanted_by 'multi-user.target'
  unit_after 'glusterd.service'
end
