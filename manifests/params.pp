# == Class: oauth2_proxy::params
#
# This class should be considered private.
#
class oauth2_proxy::params {
  $manage_user      = true
  $user             = 'oauth2'
  $manage_group     = true
  $group            = $user
  $install_root     = '/opt/oauth2_proxy'
  $service_template = 'oauth2_proxy@.service.erb'
  $manage_service   = true
  $provider         = 'systemd'

  $version       = '2.1'
  $tarball       = "oauth2_proxy-${version}.linux-amd64.go1.6.tar.gz"
  $source        = "https://github.com/bitly/oauth2_proxy/releases/download/v${version}/${tarball}"
  $checksum      = '7a74b361f9edda0400d02602eacd70596d85b453'
  $checksum_type = 'sha1'

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $::osfamily {
    'RedHat': {
#      $provider = 'systemd'
      $shell = '/sbin/nologin'
      $systemd_path = '/usr/lib/systemd/system'
    }
    'Debian': {
#      $provider = 'debian'
      $shell = '/usr/sbin/nologin'
      $systemd_path = '/etc/systemd/system'
    }
    default: {
      fail("Module ${module_name} is not supported on operatingsystem ${::operatingsystem}")
    }
  }

  # bit.ly does not provide x86 builds
  case $::architecture {
    'x86_64': {}
    'amd64': {}
    default: {
      fail("Module ${module_name} is not supported on architecture ${::architecture}")
    }
  }
}
