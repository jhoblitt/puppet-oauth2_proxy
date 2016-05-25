# == Class: oauth2_proxy::service
#
# This class should be considered private.
#
class oauth2_proxy::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  service { 'oauth2_proxy':
    ensure => 'running',
    enable => true,
  }
}
