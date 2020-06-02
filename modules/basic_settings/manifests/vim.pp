class basic_settings::vim 
(
  $vim_version = 'installed',
  $ultisnips_url = 'https://github.com/Aliciahan/Snippets/blob/master/UltiSnips.tar.gz',
){
  package {'vim':
    ensure => $vim_version,
  }

  remote_file {'download pre-configured ultisnips':
    path    =>  '/tmp/UltiSnips.tar.gz',
    ensure  =>  present,
    source  =>  ${ultisnips_url},
  }

  case $facts['os']['name'] {
    'RedHat','CentOS: {
    }
    /^(Debian|Ubuntu)$/: {

    }
  }
}
