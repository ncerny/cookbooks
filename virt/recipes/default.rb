#
# Cookbook:: virt
# Recipe:: default
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

include_recipe "#{cookbook_name}::kubernetes"

# include_recipe "#{cookbook_name}::network"
# include_recipe "#{cookbook_name}::sshd"
# include_recipe "#{cookbook_name}::time"
# include_recipe "#{cookbook_name}::system"
# include_recipe "#{cookbook_name}::boot"
# include_recipe "#{cookbook_name}::hab"
# include_recipe "#{cookbook_name}::cl_storage"
# include_recipe "#{cookbook_name}::cl_vip"
# include_recipe "#{cookbook_name}::cl_services"
# include_recipe "#{cookbook_name}::tftpd"
#
# node['infra']['additional_packages'].each do |pkg|
#   package pkg
# end
