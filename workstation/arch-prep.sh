#!/bin/bash

set -e

dev=$1

if [[ -z "${dev}" ]]; then
  echo "You must specify a disk to install on."
  exit 1
fi

timedatectl set-ntp true

# Prepare Disks
dd if=/dev/zero of=/dev/${dev} bs=8M count=1
parted /dev/${dev} mklabel gpt

# ESP
parted /dev/${dev} mkpart ESP fat32 1MiB 550MiB
parted /dev/${dev} set 1 esp on
mkfs.fat -F32 /dev/${dev}1

# root
parted /dev/${dev} mkpart primary ext4 551MiB 20.5GiB
mkfs.ext4 /dev/${dev}2 -L arch_os

mount /dev/${dev}2 /mnt
mkdir /mnt/boot
mount /dev/${dev}1 /mnt/boot

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

# swap
parted /dev/${dev} mkpart primary linux-swap 20.5GiB 24.5GiB
mkswap /dev/${dev}3
swapon /dev/${dev}3

# home
parted /dev/${dev} mkpart primary xfs 24.5GiB 100%
mkfs.xfs /dev/${dev}4 -L home

echo 'curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | bash'
echo 'hab pkg install ncerny/infra-cookbook --channel unstable'
echo 'hab run ncerny/infra-cookbook --channel unstable'
echo 'passwd'
echo 'bootctl install'

arch-chroot /mnt
#arch-chroot /mnt passwd
#arch-chroot /mnt bootctl install
