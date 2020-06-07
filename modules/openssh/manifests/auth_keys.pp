define openssh::auth_keys (
  $ensure = "present",
  $keys = undef,
){
  file { "/etc/ssh/authorized_keys/${name}":
    ensure  => $ensure,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => inline_template("<% @keys.each do |key| %><%= key %>\n<% end %>"),
  }
}
