default['audit']['reporter'] = 'chef-server-automate'
default['audit']['fetcher'] = 'chef-server'
default['audit']['interval']['enabled'] = true
default['audit']['interval']['time'] = 360
default['audit']['profiles'] =
  case node['platform']
  when 'centos'
    [
      { name: 'cis-centos7-level2', compliance: 'admin/cis-centos7-level2' },
      { name: 'linux-baseline', compliance: 'admin/linux-baseline' },
      { name: 'linux-patch-baseline', compliance: 'admin/linux-patch-baseline' },
      { name: 'ssh-baseline', compliance: 'admin/ssh-baseline' },
    ]
  else
    [
      { name: "#{node['os']}-baseline", compliance: "admin/#{node['os']}-baseline" },
      { name: "#{node['os']}-patch-baseline", compliance: "admin/#{node['os']}-patch-baseline" },
      { name: 'ssh-baseline', compliance: 'admin/ssh-baseline' },
    ]
  end
