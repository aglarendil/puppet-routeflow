Exec
{
 path=>['/bin','/usr/bin','/sbin','/usr/sbin','/usr/local/bin','/usr/local/sbin'],
 logoutput=>true
}
$rfpath='/home/user/RouteFlow'
class {routeflow: rfpath => $rfpath }
