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
    start  => "PYTHONPATH=\$PYTHONPATH:${rfpath} ${rfpath}/rfserver/rfserver.py /etc/rfserver.mapping.csv &" ,
    stop   => "kill `pgrep -f rfserver.py`",
    status => "pgrep -f rfserver.py",
    ensure => $ensure
  }
  File['/etc/rfserver.mapping.csv']->Service['rfserver']
}
