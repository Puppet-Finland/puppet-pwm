host { $facts['my_host']:
  ensure => 'present',
  ip     => $facts['my_ip'],
  target => '/etc/hosts',
}
