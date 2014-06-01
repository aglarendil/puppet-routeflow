class routeflow::rfserver ( 
  $rfpath,
  $ensure = running,
  $vms = {}
)
{
  file {'/etc/rfserver.mapping.csv':
    content => template("routeflow/rftestconfig.csv.erb")
  }
  service {'rfserver':
    provider => base,
    start  => "PYTHONPATH=\$PYTHONPATH:${rfpath} ${rfpath}/rfserver/rfserver.py /etc/rfserver.mapping.csv 1>/var/log/rfserver.log 2>&1 &" ,
    stop   => "pkill -f rfserver.py",
    status => "pgrep -f rfserver.py",
    ensure => $ensure
  }
  File['/etc/rfserver.mapping.csv']->Service['rfserver']
}
