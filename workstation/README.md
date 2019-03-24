# workstation

TODO: Enter the cookbook description here.

curl https://raw.githubusercontent.com/ncerny/cookbooks/master/infra/arch-prep.sh | bash
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | bash
hab pkg install ncerny/infra --channel unstable
hab run ncerny/infra --channel unstable --strategy at-once
passwd
bootctl install
