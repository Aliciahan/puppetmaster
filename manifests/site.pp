node default {
  include stdlib

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  File {
    backup     => false,
    ignore => ['.svn', '.gitignore', '*.swp', '.*.swp'],
  }

  stage { 'first': before => Stage['main'] }

  hiera_include('classes')

  Archive {
    provider => 'ruby',
  }

}
