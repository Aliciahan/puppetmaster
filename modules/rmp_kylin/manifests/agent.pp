class rmp_kylin::agent (

  $agent_version = 'installed',
  $ambari_server_hostname = 'hdp1.home',

) {
  include ::rmp_kylin
  
  package { 'ambari-agent':
    ensure => $agent_version,
    tag    => 'ambari',
  }

  service{'ambari-agent':
    ensure => running,
  }

  file {"/etc/ambari-agent/conf/ambari-agent.ini":
    ensure  => file,
    content => alternative_template('rmp_kylin', 'etc.ambari-agent.conf.ambari-agent.ini.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify => Exec['kylin-ambari-agent-restart'],
  }

  exec { 'kylin-ambari-agent-restart':
    command     => 'systemctl restart ambari-agent',
    refreshonly => true,
  }

}
