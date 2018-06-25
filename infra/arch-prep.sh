#!/bin/bash

dev=sda

timedatectl set-ntp true


# Prepare Disks
parted /dev/sda mklabel gpt

# ESP
parted /dev/sda mkpart ESP fat32 1MiB 550MiB
parted /dev/sda set 1 esp on
mkfs.fat -F32 /dev/sda1

# root
parted /dev/sda mkpart primary ext4 551MiB 20.5GiB
mkfs.ext4 /dev/sda2 -L arch_os

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

# swap
parted /dev/sda mkpart primary linux-swap 20.5GiB 24.5GiB
mkswap /dev/sda3
swapon /dev/sda3

# data
parted /dev/sda mkpart primary xfs 24.5GiB 100%
mkfs.xfs /dev/sda4 -L data

echo 'curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | bash'
echo 'hab pkg install ncerny/infra-cookbook --channel unstable'
echo 'hab run ncerny/infra-cookbook --channel unstable'
echo 'passwd'
echo 'bootctl install'

arch-chroot /mnt
#arch-chroot /mnt passwd
#arch-chroot /mnt bootctl install
