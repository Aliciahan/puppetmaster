class basic_settings 
(
){

  # Some Color Settings
  file {'/etc/profile.d/alicia_profile.sh': 
    content => alternative_template("basic_settings", "alicia_profile.sh.erb"),
    mode    => '0755',
  }

  case $facts['os']['name'] {
    'RedHat','CentOS': {
      file {'colorls setting up':
        path    => 	'/etc/profile.d/colorls.sh',
        mode    => 	'0644',
        content => 	alternative_template("basic_settings","colorls.sh.erb"),
      }
    }
    /^(Debian|Ubuntu)$/: {
      # Setting up NTP
      class { 'ntp':
        servers => [ '0.fr.pool.ntp.org', '1.fr.pool.ntp.org' , '2.fr.pool.ntp.org' , '3.fr.pool.ntp.org' ],
      }
    }
  }

}
