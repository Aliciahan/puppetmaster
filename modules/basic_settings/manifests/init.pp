class basic_settings 
(
  $vim_version = 'installed',
){
  #require stdlib::stages
  package {'vim':
	ensure => $vim_version,
  }

  file {'/etc/profile.d/alicia_profile.sh': 
    content => alternative_template("basic_settings", "alicia_profile.sh.erb"),
    #content => template("basic_settings/alicia_profile.sh.erb"),
    mode    => '0755',
  }
}
