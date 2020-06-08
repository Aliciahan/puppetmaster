class rmp_kylin::server (

  $server_version = 'installed',

) {
  include ::rmp_kylin
  
  package { 'ambari-server':
    ensure => $server_version,
    tag    => 'ambari',
  }
  ->
  exec{'setup ambari server':
    command => '/usr/sbin/ambari-server setup --silent',
  }

  service{'ambari-server':
    ensure => running,
  }
}
