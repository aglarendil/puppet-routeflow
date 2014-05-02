define routeflow::vm::config(
  $quagga_interfaces={},
  $rf_interfaces={}
)
{

  $templates_def_output=hiera('::routeflow::vm::templates_output')
  $templates_output="$templates_def_output/$name"
  $config_dirs=hiera_array('::routeflow::vm::config_dirs')
  $prefixed_config_dirs=prefix($config_dirs,"$templates_output")
  $lxc_dir=hiera('lxc_dir')
  file {$prefixed_config_dirs:
    ensure => directory
  }
  
  file {"$templates_output/rootfs/etc/network/interfaces":
    content =>template('routeflow/vms/network/interfaces.erb')
  }

  file {"$templates_output/rootfs/etc/quagga/daemons":
    source =>'puppet:///modules/routeflow/quagga/daemons'
  }

  file {"$templates_output/rootfs/etc/quagga/debian.conf":
    source =>'puppet:///modules/routeflow/quagga/debian.conf'
  }
 
  file {"$templates_output/rootfs/etc/quagga/ospfd.conf":
    content =>template('routeflow/vms/quagga/ospfd.conf.erb')
  }
  
  file {"$templates_output/rootfs/etc/quagga/zebra.conf":
    content =>template('routeflow/vms/quagga/zebra.conf.erb')
  }

  file {"$templates_output/rootfs/etc/rc.local":
    source => "puppet:///modules/routeflow/rc.local"
  }

  file {"$templates_output/rootfs/etc/sysctl.conf":
    source => "puppet:///modules/routeflow/sysctl.conf"
  }
  
  file {"$templates_output/config":
    content => template('routeflow/vms/config.erb')
  }

  $rfclient_path=hiera('rfclient_path')

  file {"$templates_output/rootfs/root/run_rfclient.sh":
       source => "puppet:///modules/routeflow/run_rfclient.sh",
       mode => 0755
  }

  file {"$templates_output/rootfs/opt/rfclient/rfclient":
    mode=> 0755,
    owner=>'root',
    group=>'root',
    source => "file://$rfclient_path"
  }

  
}
