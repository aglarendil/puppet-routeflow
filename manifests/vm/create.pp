define routeflow::vm::create (
  $quagga_interfaces={},
  $rf_interfaces={},
)
{
 $templates_def_output=hiera('::routeflow::vm::templates_output')
 $templates_output="$templates_def_output/$name"
 $lxc_dir=hiera('lxc_dir')
 Class['::Routeflow::Vm::Base']->::Routeflow::Vm::Create<||>
 exec {"lxc-stop -n $name && lxc-destroy -n $name || true": provider=> shell } -> exec {"lxc-clone -o base -n $name": } 
 Exec["lxc-clone -o base -n $name"]->Routeflow::Vm::Config[$title]
 routeflow::vm::config {"$name": quagga_interfaces=>$quagga_interfaces, rf_interfaces=>$rf_interfaces}
 exec {"cp configs to VM $name":
      command => "rsync -avx $templates_output/ $lxc_dir/$name/ "
 }
 exec{"lxc-start -n $name -d":}
 Routeflow::Vm::Config[$name]->Exec["cp configs to VM $name"]->Exec["lxc-start -n $name -d"]
}
