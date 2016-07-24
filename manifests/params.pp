# == Class: oauth2_proxy::params
#
# This class should be considered private.
#
#
class oauth2_proxy::params {
  $manage_user      = true
  $user             = 'oauth2'
  $manage_group     = true
  $group            = $user
  $install_root     = '/opt/oauth2_proxy'
  $service_template = 'oauth2_proxy.service.erb'
  $manage_service   = true

  $version  = '2.0.1'
  $tarball  = "oauth2_proxy-${version}.linux-amd64.go1.4.2.tar.gz"
  $source   = "https://github.com/bitly/oauth2_proxy/releases/download/v${version}/${tarball}"
  $checksum = '950e08d52c04104f0539e6945fc42052b30c8d1b'

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $::osfamily {
    'RedHat': {}
    'Debian': {}
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
