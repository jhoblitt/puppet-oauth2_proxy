# == Class: oauth2_proxy::config
#
# This class should be considered private.
#
class oauth2_proxy::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/etc/oauth2_proxy/oauth2_proxy.conf':
    ensure  => file,
    owner   => $::oauth2_proxy::user,
    group   => $::oauth2_proxy::group,
    mode    => '0440',
    content => template("${module_name}/oauth2_proxy.conf.erb"),
  }
}
