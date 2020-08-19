# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include hdp_manual
class hdp_manual (

  $hdp_user = hdp_manual::params::hdp_user,
  $hdp_group = hdp_manual::params::hdp_group,

)inherits hdp_manual::params{


  group { $hdp_group:
    ensure  => 'present',
    comment => 'hdfs group',
  }


  user { $hdp_user:
    ensure  => 'present',
    comment => 'hdfs user',
    groups  => [
      $hdp_group,
    ],
    home    => "/home/${hdp_user}",
    shell   => '/bin/bash',
  }


  file {'/opt/hdp_jdk_ressource':
    ensure =>  'directory',
    owner  =>  $hdp_user,
    group  =>  $hdp_group,
  }

  include hdp_manual::hdp_jdk

}
