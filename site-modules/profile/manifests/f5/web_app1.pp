class profile::f5::web_app1(
  Array[String[1]] $stock_monitors = [ '/Common/https' ],
  String[1]        $interval       = '10',
  Array[Hash]      $pool_members   =  [
    { name => '/Common/WWW_Server_1', port => '443', ip => '10.138.0.4' },
    { name => '/Common/WWW_Server_2', port => '443', ip => '10.138.0.3' },
  ]
) {

  $app_name = $name.split('::')[2]
  
  f5_monitor { "/Common/https_custom_${app_name}":
    ensure             => present,
    alias_address      => '*',
    alias_service_port => '*',
    interval           => $interval,
    manual_resume      => 'disabled',
    parent_monitor     => '/Common/https',
    receive_string     => 'Server\:',
    reverse            => 'disabled',
    send_string        => 'HEAD / HTTP/1.0\r\n\r\n',
    time_until_up      => '0',
    timeout            => '16',
    transparent        => 'disabled',
    up_interval        => '0',
    provider           => 'https',
  }
  
  $pool_members.each |$m| {
    f5_node { $m['name']:
      ensure                   => present,
      address                  => $m['ip'],
      description              => "${m['name']} for web application 1",
      availability_requirement => 'all',
      health_monitors          => ['/Common/icmp'],
    }
  }
  
  f5_pool { "/Common/puppet_pool_${app_name}":
    ensure                    => present,
    members                   => $pool_members.map |$m| { { name => $m['name'], port => $m['port'] } },
    availability_requirement  => 'all',
    health_monitors           => $stock_monitors + "/Common/https_custom_${app_name}",
    require                   => $pool_members.map |$m| { F5_node[$m['name']] },
  }
  
  f5_virtualserver { "/Common/puppet_vs_${app_name}":
    ensure                     => present,
    provider                   => standard,
    default_pool               => "/Common/puppet_pool_${app_name}",
    destination_address        => '192.168.80.100',
    destination_mask           => '255.255.255.255',
    http_profile               => '/Common/http',
    service_port               => '443',
    protocol                   => 'tcp',
    source_address_translation => 'automap',
    source                     => '0.0.0.0/0',
    vlan_and_tunnel_traffic    => { 'enabled' => ['/Common/internal'] },
    require                    => F5_pool["/Common/puppet_pool_${app_name}"],
  }
}