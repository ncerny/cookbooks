pkg_name="core"
pkg_origin="ncerny"
pkg_version=$(awk '/^version/ { tmp=substr($2,2,length($2)-2); print tmp }' ../metadata.rb)
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_upstream_url="http://chef.io"
pkg_scaffolding="echohack/scaffolding-chef"
scaffold_policy_name="Policyfile"
scaffold_policyfiles_path="$PLAN_CONTEXT/.."
