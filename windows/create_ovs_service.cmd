sc create neutron-ovs-agent binPath= "\"C:\OpenStack\cloudbase\nova\bin\OpenStackServiceNeutron.exe\" neutron-ovs-agent \"C:\OpenStack\cloudbase\nova\Python27\Scripts\neutron-openvswitch-agent.exe\" --config-file \"C:\OpenStack\cloudbase\nova\etc\neutron_ovs_agent.conf\"" type= own start= auto error= ignore depend= Winmgmt displayname= "OpenStack Neutron Open vSwitch Agent Service" obj= LocalSystem