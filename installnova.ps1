$ErrorActionPreference = "Stop"

$msi = "HyperVNovaCompute_Icehouse_2014_1_2.msi"

Import-Module BitsTransfer
Start-BitsTransfer "https://www.cloudbase.it/downloads/$msi"

$devstackHost = "10.14.0.26"
$password = "Pass0rd"

$msiArgs = "/i $msi /qn /l*v log.txt " + `

"ADDLOCAL=HyperVNovaCompute,NeutronHyperVAgent,CeilometerComputeAgent,iSCSISWInitiator,FreeRDP " +

"GLANCEHOST=$devstackHost " +
"RPCBACKEND=RabbitMQ " +
"RPCBACKENDHOST=$devstackHost " + 
"RPCBACKENDPASSWORD=Passw0rd " +

"INSTANCESPATH=C:\OpenStack\Instances " +
"LOGDIR=C:\OpenStack\Log " +

"RDPCONSOLEURL=http://$devstackHost:8000 " +

"ADDVSWITCH=0 " +
"VSWITCHNAME=external " +

"USECOWIMAGES=1 " +
"FORCECONFIGDRIVE=1 " +
"CONFIGDRIVEINJECTPASSWORD=1 " +
"DYNAMICMEMORYRATIO=1 " +
"ENABLELOGGING=1 " + 
"VERBOSELOGGING=1 " +

"NEUTRONURL=http://$devstackHost:9696 " +
"NEUTRONADMINTENANTNAME=service " +
"NEUTRONADMINUSERNAME=neutron " +
"NEUTRONADMINPASSWORD=$password " +
"NEUTRONADMINAUTHURL=http://$devstackHost:35357/v2.0 " +

"CEILOMETERADMINTENANTNAME=service " +
"CEILOMETERADMINUSERNAME=ceilometer " +
"CEILOMETERADMINPASSWORD=$password " +
"CEILOMETERADMINAUTHURL=http://$devstackHost:35357/v2.0 "

$p = Start-Process -Wait "msiexec.exe" -ArgumentList $msiArgs -PassThru
if($p.ExitCode) { throw "msiexec failed" }
