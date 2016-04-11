Param(
	$ClusterNodes = $(throw '-Cluster nodes are required'),
	[String]$DiskWitnessShare = $(throw '-Disk witness is required')
)


$clustername = 'testcluster2'

New-Cluster $clustername -staticAddress 192.168.78.19 -Node $ClusterNodes -NoStorage
Set-ClusterQuorum -FileShareWitness $DiskWitnessShare

