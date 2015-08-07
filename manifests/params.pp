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

  # in theory, this module should work on any linux distro that uses systemd
  # but it has only been tested on el7
  case $::osfamily {
    'RedHat': { }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

}

