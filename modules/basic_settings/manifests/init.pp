class basic_settings 
(
){

  file {'/etc/profile.d/alicia_profile.sh': 
    content => alternative_template("basic_settings", "alicia_profile.sh.erb"),
    mode    => '0755',
  }

}
