#
# Cookbook:: cerny-cc
# Recipe:: cl_vip
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

package 'ucarp'

template '/usr/local/bin/vip-up.sh' do
  source 'vip-up.sh.erb'
  owner 'root'
  group 'root'
  mode '0700'
end

template '/usr/local/bin/vip-down.sh' do
  source 'vip-down.sh.erb'
  owner 'root'
  group 'root'
  mode '0700'
end

directory '/etc/ucarp'

file '/etc/ucarp/vip_1.passwd' do
  owner 'root'
  group 'root'
  mode '0600'
end

systemd_service 'ucarp' do
  action [:create, :enable, :start]
  unit do
    description 'UCARP daemon'
    after 'network.target'
  end
  service do
    exec_start "/usr/bin/ucarp -i ens2 -s #{node['ipaddress']} -v 1 -o /etc/ucarp/vip_1.passwd -a 192.168.2.10 -u /usr/local/bin/vip-up.sh -d /usr/local/bin/vip-down.sh --shutdown"
    exec_stop '/bin/kill -TERM $MAINPID'
    kill_mode 'process'
    restart 'always'
  end
  install_wanted_by 'multi-user.target'
end
