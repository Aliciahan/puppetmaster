class basic_settings 
(
  $vim_version = 'installed',
){
  package {'vim':
	ensure => $vim_version,
  }
}
