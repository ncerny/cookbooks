pkg_name=$(awk '/^name/ { tmp=substr($2,2,length($2)-2); print tmp }' ../metadata.rb)
pkg_origin=ncerny
pkg_version=$(awk '/^version/ { tmp=substr($2,2,length($2)-2); print tmp }' ../metadata.rb)
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_scaffolding="echohack/scaffolding-chef"
scaffold_policy_name="Policyfile"
pkg_description="My base and infrastructure cookbook for my environment."
pkg_upstream_url="https://github.com/ncerny/cookbooks/"
