# This manifest is only used by Vagrant

$servermonitor = 'root@localhost'

include ::packetfilter::endpoint
include ::monit

class { '::dirsrv':
    manage_config                => true,
    manage_monit                 => true,
    manage_packetfilter          => true,
    serveridentifier             => 'vagrant',
    suffix                       => 'dc=example,dc=org',
    rootdn                       => 'cn=Directory Manager',
    rootdn_pwd                   => 'vagrant',
    server_admin_pwd             => 'vagrant',
    config_directory_admin_pwd   => 'vagrant',
    admin_bind_ip                => '0.0.0.0',
    dirsrv_allow_ipv4_address    => '0.0.0.0/0',
    dirsrv_allow_ipv6_address    => '::1',
    admin_srv_allow_ipv4_address => '0.0.0.0/0',
    admin_srv_allow_ipv6_address => '::1',
    allow_anonymous_access       => 'on',
}

# Pwm-specific configurations to 389 Directory Server
include ::pwm::dirsrv
