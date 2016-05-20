# == Class: oauth2_proxy::install
#
# This class should be considered private.
#
class oauth2_proxy::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $version = '2.0.1'
  $base = "oauth2_proxy-${version}.linux-amd64.go1.4.2"
  $tarball = "${base}.tar.gz"

  archive { $tarball:
    ensure        => present,
    source        => "https://github.com/bitly/oauth2_proxy/releases/download/v${version}/${tarball}",
    path          => "${::oauth2_proxy::install_root}/${tarball}",
    extract       => true,
    extract_path  => $::oauth2_proxy::install_root,
    checksum      => '950e08d52c04104f0539e6945fc42052b30c8d1b',
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
}
