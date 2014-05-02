class routeflow::controller::pox
(
 $ensure = running,
 $pox_path = '',
 $rfpath
)

{
  ensure_resource('package','procps',{'ensure' => present })
  service  { 'controller_pox':
    provider => 'base',
    start    => "PYTHONPATH=\$PYTHONPATH:${rfpath} ${pox_path}pox.py log.level --=DEBUG topology openflow.topology openflow.discovery rfproxy rfstats &",
    stop     => 'kill `pgrep -f pox.py`',
    status   => 'pgrep -f pox.py',
    require  => Package['procps'],
    ensure   => $ensure
  }
  

}


