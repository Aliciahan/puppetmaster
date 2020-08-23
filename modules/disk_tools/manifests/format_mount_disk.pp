# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include disk_tools::format_mount_disk
class disk_tools::format_mount_disk (
  $disk_dev     = '/dev/sdb',
  $partition_standard = 'gpt', # gpt or mbr
  $mount_folder = '/data',
){

  # Mount Disk Data 
  file{ 'data-repo':
    ensure => directory,
    path   => $mount_folder,
    mode   => '0666',
  }
  -> exec { 'format-disk':
    command => "/sbin/parted -s ${disk_dev} mklabel ${partition_standard} && sleep 2 &&\
    /sbin/parted -s -a opt ${disk_dev} mkpart primary ext4 0% 100% && sleep 2 &&\
    /sbin/mkfs.ext4 ${disk_dev}1",
    unless  => "/sbin/blkid -t TYPE=ext4 ${disk_dev}1",
  }
  -> mount { $mount_folder:
    ensure  => 'mounted',
    device  => "${disk_dev}1",
    fstype  => 'ext4',
    options => 'defaults',
    atboot  => 'true',
  }
}
