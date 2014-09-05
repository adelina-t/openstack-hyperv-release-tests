function CheckStopService($serviceName) {
    $s = get-service | where {$_.Name -eq $serviceName}
    if($s -and $s.Status -ne "Stopped") { net stop $serviceName }
}

CheckStopService nova-compute
CheckStopService neutron-hyperv-agent
CheckStopService ceilometer-agent-compute