class openssh (
){

  $os_family = $facts['os']['name']

  package { [ 'openssl', 'openssh-server' ]:
    ensure => latest,
  } ->

  file { '/etc/ssh/authorized_keys':
    ensure  => directory,
    mode    => '0644',
    recurse => true,
    purge   => true,
    owner   => 'root',
    group   => 'root',
  }
  $authorized_keys = hiera_hash('openssh::authorized_keys', {})
  create_resources('openssh::auth_keys', $authorized_keys)

  file { '/etc/ssh/sshd_config':
    content => alternative_template('openssh',"sshd_config.erb"),
  }


}
