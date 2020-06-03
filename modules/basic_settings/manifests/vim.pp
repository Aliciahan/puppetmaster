class basic_settings::vim 
(
  $vim_version = 'installed',
  $ultisnips_url = 'https://raw.githubusercontent.com/Aliciahan/Snippets/master/UltiSnips.tar.gz',
  $bundle_file_centos = 'https://github.com/Aliciahan/Snippets/blob/master/bundle-centos.tgz?raw=true',
  $vimrc_url = 'https://github.com/Aliciahan/Snippets/raw/master/.vimrc',
  $vundle_git_url = 'https://github.com/VundleVim/Vundle.vim.git',
  
){
  case $facts['os']['name'] {
    'RedHat','CentOS': {

      $common_vim_repo ='/usr/share/vim/vim80/plugin'

      file {'prepare_common_vimrc_repo':
        path   => $common_vim_repo,
        ensure => directory,
        mode   => '755',
      }

    }
    /^(Debian|Ubuntu)$/: {
      $common_vim_repo ='/usr/share/vim/addons/plugin' 
    }
  }

  package {'vim':
    ensure => $vim_version,
  }

  package {'git':
    ensure => "installed",
  }

  #automake gcc gcc-c++ make kernel-devel cmake python-devel python3-devel ncurses-devel ncurses-libs

  package {'automake':
    ensure => "installed",
  }
  package {'gcc':
    ensure => "installed",
  }
  package {'gcc-c++':
    ensure => "installed",
  }
  package {'make':
    ensure => "installed",
  }
  package {'cmake':
    ensure => "installed",
  }
  package {'kernel-devel':
    ensure => "installed",
  }
  package {'python3-devel':
    ensure => "installed",
  }
  package {'ncurses-devel':
    ensure => "installed",
  }
  package {'ncurses-libs':
    ensure => "installed",
  }

  file {'prepare_common_vim_repo':
    path   => "${common_vim_repo}/UltiSnips",
    ensure => directory,
    mode   => '755',
  }


  #file {'prepare_common_vimrc_repo':
  #  path   => "/etc/vim",
  #  ensure => directory,
  #  mode   => '755',
  #}

  archive { '/opt/UltiSnips.tgz': 
    ensure            => present,
    extract           => true,
    extract_path      => "${common_vim_repo}/UltiSnips",
    source            => $ultisnips_url,
    provider          => 'wget',
    download_options  => '--continue',
    require           => File['prepare_common_vim_repo'],
  }

  #archive { '/opt/bundle.tgz': 
  #  ensure 	=> present,
  #  extract	=> true,
  #  extract_path => "${common_vim_repo}",
  #  source       => $bundle_file_centos,
  #  provider     => 'wget',
  #  download_options =>  '--continue',
  #  require          =>  File['prepare_common_vim_repo'],
  #}

  archive { '/etc/vimrc': 
    ensure    => present,
    source    => $vimrc_url,
    provider  => 'wget',
    require   =>  File['prepare_common_vimrc_repo'],
  }->
  #exec { 'manuall-install-vundle':
  #  cwd     => $common_vim_repo,
  #  command => "git clone ${vundle_git_url} ${common_vim_repo}/bundle/Vundle.vim && touch /etc/vundle_installed",
  #  path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
  #  onlyif  => "test ! -e /etc/vundle_installed",
  #}->
  #exec { 'manuall-install-plugins':
  #  cwd     => $common_vim_repo,
  #  command => "vim +PluginInstall +qall && touch /etc/vim_plugin_installed",
  #  path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
  #  onlyif  => "test ! -e /etc/vim_plugin_installed",
  #}
  git { 'the-nerd-tree':
    path   => "$common_vim_repo/the-nerd-tree",
    ensure => present,
    branch => 'master',
    latest => true,
    origin => 'https://github.com/vim-scripts/The-NERD-tree.git',
  }


  file {'colorls setting up':
    path    => 	'/etc/profile.d/colorls.sh',
    mode    => 	'0644',
    content => 	alternative_template("basic_settings","colorls.sh.erb"),
  }
}
