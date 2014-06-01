class routeflow(
  $rfpath
)
{

  $controller='pox'
  #  packages
# vm_hash=...
 
 class {'::routeflow::vm::base':}
 $vm_hash=hiera_hash('vms')
 create_resources(routeflow::vm::create,$vm_hash)
 $lxc_bridge=hiera('lxc_bridge')
 notify{"$lxc_bridge":}
 $ip=getvar("ipaddress_${lxc_bridge}")
 $bind_ips=['127.0.0.1',$ip]

 class {'::mongodb': bind_ip=>$bind_ips, logappend=>true, journal=>true} 

 class {"routeflow::controller::$controller": pox_path=>'/home/user/RouteFlow/pox/', rfpath => $rfpath }
 class {"routeflow::rfserver": rfpath=>$rfpath, vms=>$vm_hash}
 Service['mongodb']->Class['::Routeflow::Mongodb']
 Service['mongodb']->Class['::Routeflow::Rfserver']
 Service['mongodb']->Class["::Routeflow::Controller::$controller"]
 Class['::Routeflow::Mongodb']->Class['::Routeflow::Rfserver']
 Class['::Routeflow::Mongodb']->Routeflow::Vm::Create<||>
 Service['mongodb']->Routeflow::Vm::Create<||>
 class {'routeflow::mongodb':}
 $ports=getports(hiera('vms'))
 Service['controller_pox']->Service['rfserver']
 Routeflow::Vm::Create<||>->Class[Routeflow::Ovs]
 exec{'/usr/bin/ovs-vsctl del-br dp0 && /usr/bin/ovs-vsctl emer-reset || true':}->class {'routeflow::ovs': ports=>$ports, bridges=> hiera('dps')} 
}
