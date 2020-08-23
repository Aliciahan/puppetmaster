# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include hdp_manual::ambari_repo
class hdp_manual::ambari_repo(
  $repo = $hdp_manual::params::ambari_repo_version,
  $gpg_key = $hdp_manual::params::gpg_key,
  $gpg_server = $hdp_manual::params::gpg_server,
) inherits hdp_manual::params {
  #### Install apt package
  $distro = downcase($::facts['os']['distro']['codename'])
  case $distro {
    'xenial': {$ubuntu_version = '16'}
    'trusty': {$ubuntu_version = '14'}
    default: {$ubuntu_version = '18'}
  }

  apt::source { 'ambari':
    location => "http://public-repo-1.hortonworks.com/ambari/ubuntu${ubuntu_version}/2.x/updates/${repo}",
    release  => 'Ambari',
    repos    => 'main',
    key      => {
      'id'     => $gpg_key,
      'server' => $gpg_server,
    }
  }

  Exec['apt_update']->Package<|tag == 'ambari'|>
  Apt::Source['ambari']->Package<|tag == 'ambari'|>
}

