class rmp_kylin (

  $repo = '2.7.4.0',

  $gpg_key = 'DF52ED4F7A3A5882C0994C66B9733A7A07513CAD',
  $gpg_server ='pgp.mit.edu',

) {

  #### Mount Disk Data 
  file{ "data-repo":
    path    => "/data",
    ensure  => directory,
    mode    => '0666',
  }->
  exec {'/sbin/mkfs.ext4 /dev/sdb':
    unless => '/sbin/blkid -t TYPE=ext4 /dev/sdb'
  } ->
  mount { "/data":
    device  => "/dev/sdb",
    fstype  => "ext4",
    ensure  => "mounted",
    options => "defaults",
    atboot  => "true",
  }




  #### Install apt package
  $distro = downcase($::facts['os']['distro']['codename'])
  case $distro {
    "xenial": {$ubuntu_version = '16'}
    "trusty": {$ubuntu_version = '14'}
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
