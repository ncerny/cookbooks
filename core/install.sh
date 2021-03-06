#!/bin/bash

if [[ -n "$1" ]] && [[ ! $(mount | grep /mnt) ]]; then
  parted -s /dev/$1 mklabel gpt
  parted -s /dev/$1 mkpart ESP fat32 1MiB 551MiB
  parted -s /dev/$1 set 1 esp on
  parted -s /dev/$1 set 1 boot on
  parted -s /dev/$1 mkpart primary linux-swap 551MiB 4.5GiB
  parted -s /dev/$1 mkpart primary ext3 4.5GiB 100%

  mkfs.fat /dev/${1}1
  mkfs.ext4 /dev/${1}3
  mkswap /dev/${1}2
  swapon /dev/${1}2
  mount /dev/${1}3 /mnt
  mkdir -p /mnt/boot
  mount /dev/${1}1 /mnt/boot
elif [[ ! $(mount | grep /mnt) ]]; then
  echo "Usage: install.sh <root_disk>"
  exit 1
fi
#if [[ -d '/sys/firmware/efi/efivars' ]]; then

timedatectl set-ntp true

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

curl -SsL https://api.bintray.com/content/habitat/stable/linux/x86_64/hab-%24latest-x86_64-linux.tar.gz?bt_package=hab-x86_64-linux -o /tmp/hab.tgz
tar -xvzf /tmp/hab.tgz -C /mnt/usr/local/bin --strip-components 1

arch-chroot /mnt hab start ncerny/core
