class routeflow::ovs (
 $bridges={},
 $ports={}
)
{
  Vs_bridge { ensure=>present }
  create_resources('vs_bridge',$bridges)
  create_resources('vs_port',$ports)

}
