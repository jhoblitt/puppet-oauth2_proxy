# == Define: oauth2_proxy::instance
#
define oauth2_proxy::instance(
  $config,
  $manage_service = $::oauth2_proxy::params::manage_service,
  $provider       = $::oauth2_proxy::params::provider,
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

  file { "/var/log/oauth2_proxy/${title}.log":
    ensure => file,
    owner  => $::oauth2_proxy::user,
    group  => $::oauth2_proxy::group,
    mode   => '0644',
  }

  case $provider {
    'debian': {
      file { "/etc/init.d/oauth2_proxy@${title}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => template("${module_name}/oauth2_proxy.initd.erb"),
      }
    }
    'upstart': {
      file { "/etc/init/oauth2_proxy@${title}.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/oauth2_proxy.init.erb"),
      }
    }
    default: {}
  }

  if $manage_service {
    case $provider {
      'debian': {
        service { "oauth2_proxy@${title}":
          ensure    => 'running',
          enable    => true,
          subscribe => File["/etc/init.d/oauth2_proxy@${title}", "/etc/oauth2_proxy/${title}.conf"],
          provider  => $provider,
        }
      }
      'upstart': {
        service { "oauth2_proxy@${title}":
          ensure    => 'running',
          enable    => true,
          subscribe => File["/etc/init/oauth2_proxy@${title}.conf", "/etc/oauth2_proxy/${title}.conf"],
          provider  => $provider,
        }
      }
      'systemd': {
        service { "oauth2_proxy@${title}":
          ensure    => 'running',
          enable    => true,
          subscribe => File["/etc/oauth2_proxy/${title}.conf"],
          provider  => $provider,
        }
      }
      default: {}
    }
  }
}
