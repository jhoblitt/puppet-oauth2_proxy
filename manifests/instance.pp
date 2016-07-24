# == Define: oauth2_proxy::instance
#
define oauth2_proxy::instance(
  $config,
  $manage_service = $::oauth2_proxy::params::manage_service,
) {
  validate_bool($manage_service)
  validate_hash($config)

  file { "/etc/oauth2_proxy/${title}.conf":
    ensure  => file,
    owner   => $::oauth2_proxy::user,
    group   => $::oauth2_proxy::group,
    mode    => '0440',
    content => template("${module_name}/oauth2_proxy.conf.erb"),
  }

  if $manage_service {
    service { "oauth2_proxy@${title}":
      ensure    => 'running',
      enable    => true,
      subscribe => File["/etc/oauth2_proxy/${title}.conf"],
      provider  => systemd,
    }
  }
}
