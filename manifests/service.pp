# == Class: oauth2_proxy::service
#
# This class should be considered private.
#
class oauth2_proxy::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/usr/lib/systemd/system/oauth2_proxy.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/oauth2_proxy.service.erb"),
  } ~>
  service { 'oauth2_proxy':
    ensure => 'running',
    enable => true,
  }
}
