$pkg_name=(Get-Content ..\metadata.rb | Select-String -pattern "^name") -Replace "name .(\w).", '$1'
$pkg_origin="ncerny"
$pkg_version=(Get-Content ..\metadata.rb | Select-String -pattern "^version") -Replace "[^0-9.]", ''
$pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
$pkg_upstream_url="http://chef.io"
$pkg_scaffolding="echohack/scaffolding-chef"
$scaffold_policy_name="Policyfile"
