# == Class: oauth2_proxy::install
#
# This class should be considered private.
#
class oauth2_proxy::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $tarball = regsubst($::oauth2_proxy::source, '^.*/([^/]+)$', '\1')
  $base    = regsubst($tarball, '(\w+).tar.gz$', '\1')

  archive { $tarball:
    ensure        => present,
    source        => $::oauth2_proxy::source,
    path          => "${::oauth2_proxy::install_root}/${tarball}",
    extract       => true,
    extract_path  => $::oauth2_proxy::install_root,
    checksum      => $::oauth2_proxy::checksum,
    checksum_type => 'sha1',
    user          => $::oauth2_proxy::user,
  }

  file { $::oauth2_proxy::install_root:
    ensure => directory,
    owner  => $::oauth2_proxy::user,
    group  => $::oauth2_proxy::group,
    mode   => '0755',
  }

  file { "${::oauth2_proxy::install_root}/bin":
    ensure => link,
    owner  => $::oauth2_proxy::user,
    group  => $::oauth2_proxy::group,
    target => "${::oauth2_proxy::install_root}/${base}",
  }

  file { '/etc/oauth2_proxy':
    ensure => directory,
    owner  => $::oauth2_proxy::user,
    group  => $::oauth2_proxy::group,
    mode   => '0755',
  }

  # on debian system the systemd system directory is not guaranteed to exist
  if $::osfamily == 'Debian' {
    exec { '/bin/mkdir -p /usr/lib/systemd/system':
      creates => '/usr/lib/systemd/sysem'
    }
  }

  file { '/usr/lib/systemd/system/oauth2_proxy@.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/oauth2_proxy@.service.erb"),
  }
}
