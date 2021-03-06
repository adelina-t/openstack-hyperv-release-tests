$ErrorActionPreference = "Stop"

$s = get-service | where {$_.Name -eq "neutron-ovs-agent"}
if ($s) {
    stop-service $s
    sc.exe delete neutron-ovs-agent

    # if ovs was used we will also want to delete the bridges created
    # by the agent to ensure a clean env for the next run.

    ovs-vsctl --if-exists del-br br-tun
    ovs-vsctl --if-exists del-br br-int
}

$products = gwmi Win32_Product -filter "Vendor = 'Cloudbase Solutions Srl'" | where {$_.Caption.StartsWith('OpenStack Hyper-V ')}
if ($products) {
    $msi_log_path="C:\OpenStack\Log\uninstall_log.txt"
    $log_dir = split-path $msi_log_path
    if(!(Test-Path $log_dir)) {
        mkdir $log_dir
    }

    foreach($product in $products) {
        Write-Host "Uninstalling ""$($product.Caption)"""
        $p = Start-Process -Wait "msiexec.exe" -ArgumentList "/uninstall $($product.IdentifyingNumber) /qn /l*v $msi_log_path" -PassThru
        if($p.ExitCode) { throw 'Uninstalling "$($product.Caption)" failed'}
        Write-Host """$($product.Caption)"" uninstalled successfully"
    }
}

$pythonProcesses = get-process | where {$_.Path -eq "C:\OpenStack\cloudbase\nova\Python27\python.exe"}
foreach($p in $pythonProcesses) {
    Write-Warning "Killing OpenStack Python process. This process should not be alive!"
    $p | kill -Force
}

$appPath = "C:\OpenStack\cloudbase\nova"

if(Test-Path $appPath) {
    rmdir -Recurse -Force $appPath
}

# Remove common js files used by the installer
# This needs to be added to the installer
del $env:SystemRoot\Temp\*.js -Force
