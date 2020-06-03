class basic_settings::vim 
(
  $vim_version = 'installed',
  $ultisnips_url = 'https://raw.githubusercontent.com/Aliciahan/Snippets/master/UltiSnips.tar.gz',
  $bundle_file_centos = 'https://github.com/Aliciahan/Snippets/blob/master/bundle-centos.tgz?raw=true',
  $vimrc_url = 'https://github.com/Aliciahan/Snippets/raw/master/.vimrc',
  
){
  case $facts['os']['name'] {
    'RedHat','CentOS': {
      $common_vim_repo ='/usr/share/vim/vim80'
    }
    /^(Debian|Ubuntu)$/: {
      $common_vim_repo ='/usr/share/vim/addons/plugin' 
    }
  }

  package {'vim':
    ensure => $vim_version,
  }


  file {'prepare_common_vim_repo':
    path   => "${common_vim_repo}/UltiSnips",
    ensure => directory,
    mode   => '755',
  }
  file {'prepare_common_vimrc_repo':
    path   => "/etc/vim",
    ensure => directory,
    mode   => '755',
  }
  archive { '/opt/UltiSnips.tgz': 
    ensure 	=> present,
    extract	=> true,
    extract_path => "${common_vim_repo}/UltiSnips",
    source       => $ultisnips_url,
    provider     => 'wget',
    download_options =>  '--continue',
    require          =>  File['prepare_common_vim_repo'],
  }

  archive { '/opt/bundle.tgz': 
    ensure 	=> present,
    extract	=> true,
    extract_path => "${common_vim_repo}",
    source       => $bundle_file_centos,
    provider     => 'wget',
    download_options =>  '--continue',
    require          =>  File['prepare_common_vim_repo'],
  }

  archive { '/etc/vimrc': 
    ensure 	=> present,
    source       => $vimrc_url,
    provider     => 'wget',
    require          =>  File['prepare_common_vimrc_repo'],
  }

  file {'colorls setting up':
    path    => 	'/etc/profile.d/colorls.sh',
    mode    => 	'0644',
    content => 	alternative_template("basic_settings","colorls.sh.erb"),
  }
}
