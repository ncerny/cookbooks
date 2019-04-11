#@IgnoreInspection BashAddShebang
if [ -z ${CHEF_POLICYFILE+x} ]; then
  policy_name="base"
else
  policy_name=${CHEF_POLICYFILE}
fi

scaffold_policy_name="$policy_name"
pkg_name=workstation
pkg_origin=ncerny
pkg_version=$(awk '/^version/ { ver=substr($2,2,length($2)-2); print ver }' ../metadata.rb)
pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
pkg_license=("Apache-2.0")
pkg_description="My workstation cookbook"
pkg_upstream_url="https://github.com/ncerny/cookbooks"
pkg_scaffolding="core/scaffolding-chef"
pkg_svc_user=("root")
pkg_svc_group=("root")
pkg_exports=(
  [chef_client_ident]=chef_client_ident
)
