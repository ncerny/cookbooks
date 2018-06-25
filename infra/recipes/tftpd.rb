#
# Cookbook:: infra
# Recipe:: tftpd
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

package 'tftp-hpa'

directory '/srv/tftp' do
  action :delete
  not_if { ::File.symlink?('/srv/tftp') }
end

link '/srv/tftp' do
  to '/mnt/gv0/tftp'
  link_type :symbolic
end

service 'tftpd' do
  action [:enable, :start]
end
