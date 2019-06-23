#
# Cookbook:: core
# Recipe:: default
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
%w(
  Containers
  Microsoft-Hyper-V-All
  Containers-DisposableClientVM
  Microsoft-Windows-Subsystem-Linux
).each do |feature|
  windows_feature feature do
    action :install
  end
end

include_recipe 'chocolatey'

{
  googlechrome: '75.0.3770.100',
  slack: '3.4.3',
  zoom: '4.4.53901.0616',
  git: '2.22.0',
  'docker-desktop': '2.0.0.3',
  vscode: '1.35.1',
  virtualbox: '6.0.8',
  vagrant: '2.2.4',
  'chef-workstation': '0.2.53',
  'autodesk-fusion360': '2.0.5827',
  prusaslicer: '2.0.0',
}.each do |pkg, ver|
  chocolatey_package pkg.to_s do
    action :upgrade
    version ver.to_s
    returns [0, 3010]
  end
end
