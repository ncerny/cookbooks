#
# Cookbook:: workstation
# Recipe:: gui
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

# Base-X
%w(
  glx-utils
  mesa-dri-drivers
  mesa-vulkan-drivers
  plymouth-system-theme
  xorg-x11-drv-evdev
  xorg-x11-drv-fbdev
  xorg-x11-drv-intel
  xorg-x11-drv-libinput
  xorg-x11-drv-nouveau
  xorg-x11-drv-openchrome
  xorg-x11-drv-qxl
  xorg-x11-drv-vesa
  xorg-x11-drv-wacom
  xorg-x11-server-Xorg
  xorg-x11-utils
  xorg-x11-xauth
  xorg-x11-xinit
).each do |pkg|
  package pkg do
    action :install
  end
end

# Basic Fonts
%w(
  aajohan-comfortaa-fonts
  abattis-cantarell-fonts
  dejavu-sans-fonts
  dejavu-sans-mono-fonts
  dejavu-serif-fonts
  gnu-free-mono-fonts
  gnu-free-sans-fonts
  gnu-free-serif-fonts
  google-noto-emoji-color-fonts
  google-noto-sans-cjk-ttc-fonts
  google-noto-sans-sinhala-fonts
  google-noto-serif-cjk-ttc-fonts
  jomolhari-fonts
  julietaula-montserrat-fonts
  khmeros-base-fonts
  liberation-mono-fonts
  liberation-sans-fonts
  liberation-serif-fonts
  lohit-assamese-fonts
  lohit-bengali-fonts
  lohit-devanagari-fonts
  lohit-gujarati-fonts
  lohit-gurmukhi-fonts
  lohit-kannada-fonts
  lohit-odia-fonts
  lohit-tamil-fonts
  lohit-telugu-fonts
  paktype-naskh-basic-fonts
  paratype-pt-sans-fonts
  sil-abyssinica-fonts
  sil-mingzat-fonts
  sil-nuosu-fonts
  sil-padauk-fonts
  smc-meera-fonts
  stix-fonts
  thai-scalable-waree-fonts
).each do |pkg|
  package pkg do
    action :install
  end
end

%w( lightdm slick-greeter awesome konsole ).each do |pkg|
  package pkg do
    action :install
  end
end

service 'lightdm' do
  action :enable
end

link '/usr/share/xsessions/default.desktop' do
  to '/usr/share/xsessions/awesome.desktop'
end

execute 'set-gui-default' do
  command '/usr/bin/systemctl set-default graphical.target'
  not_if "/usr/bin/systemctl get-default | grep graphical.target"
  notifies :request_reboot, 'reboot[workstation]', :immediately
end
