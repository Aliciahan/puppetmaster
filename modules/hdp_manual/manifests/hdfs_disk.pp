# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include hdp_manual::hdfs_disk
class hdp_manual::hdfs_disk (
) {
  class {'disk_tools::format_mount_disk':
    disk_dev     => '/dev/sdb',
    mount_folder => '/hdfs_data',
  }
}
