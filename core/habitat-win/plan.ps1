if ($env:CHEF_POLICYFILE -eq $null){
  $policy_name = "Policyfile"
}
else{
  $policy_name = $env:CHEF_POLICYFILE
}
  
$pkg_name="core"
$pkg_origin="ncerny"
$pkg_version=(Get-Content ..\metadata.rb | Select-String -pattern "^version") -Replace "[^0-9.]", ""
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_license=("Apache-2.0")
$pkg_build_deps=@("core/chef-dk", "core/git")
$pkg_deps=@("stuartpreston/chef-client-detox", "core/cacerts")
$pkg_description="A Chef Policy for $policy_name"
$pkg_upstream_url="http://chef.io"
  
function Invoke-Build {
  Remove-Item "$PLAN_CONTEXT/../*.lock.json" -Force
  $policyfile="$PLAN_CONTEXT/../$policy_name.rb"
  Get-Content $policyfile | ? { $_.StartsWith("include_policy") } | % {
      $first = $_.Split()[1]
      $first = $first.Replace("`"", "").Replace(",", "")
      chef install "$PLAN_CONTEXT/../$first.rb"
  }
  chef install $policyfile
}
  
function Invoke-Install {
  chef export "$PLAN_CONTEXT/../$policy_name.lock.json" $pkg_prefix
  mkdir -Path "$pkg_prefix/config"
  Copy-Item -Path "$pkg_prefix/.chef/config.rb" -Destination "$pkg_prefix/config/bootstrap-config.rb"
  Add-Content "$pkg_prefix/config/bootstrap-config.rb" -Value @"
cache_path "$($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($pkg_svc_data_path).Replace("\","/"))"
ENV['PATH'] += ";C:/WINDOWS;C:/WINDOWS/system32/;C:/WINDOWS/system32/WindowsPowerShell/v1.0;C:/ProgramData/chocolatey/bin"
ENV['PSModulePath'] += "C:/Program\ Files/WindowsPowerShell/Modules"
chef_zero.enabled true
"@
  
  Copy-Item -Path "$pkg_prefix/.chef/config.rb" -Destination "$pkg_prefix/config/client-config.rb"
  Add-Content "$pkg_prefix/config/client-config.rb" -Value @"
cache_path "$($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($pkg_svc_data_path).Replace("\","/"))"
{{#if cfg.data_collector.enable ~}}
data_collector.token "{{cfg.data_collector.token}}"
data_collector.server_url "{{cfg.data_collector.server_url}}"
{{/if ~}}
ENV['PATH'] += "{{cfg.env_path_prefix}}"
ENV['PSModulePath'] += "C:/Program\ Files/WindowsPowerShell/Modules"
ssl_verify_mode {{cfg.ssl_verify_mode}}
chef_zero.enabled true
"@
}