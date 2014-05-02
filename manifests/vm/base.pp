class routeflow::vm::base ()
{
  $lxc_dir='/var/lib/lxc'
  package {"lxc":}
  file {$lxc_dir: ensure => directory }
  exec {"lxc-create":
      command => "/usr/bin/lxc-create -t ubuntu -n base",
      unless => 'lxc-ls | grep -q base'
  }
  
  $packages = join(hiera_array('routeflow::vm::packages'), ' ')

  exec {"base-prepare":
    command => "chroot /var/lib/lxc/base/rootfs sh -c \"apt-get update && apt-get -y install $packages\""
  }
  File[$lxc_dir]->Exec['lxc-create']->Exec['base-prepare']

}
