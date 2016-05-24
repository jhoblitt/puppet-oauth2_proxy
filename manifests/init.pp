# == Class: oauth2_proxy
#
class oauth2_proxy(
  $user           = $::oauth2_proxy::params::user,
  $manage_user    = $::oauth2_proxy::params::manage_user,
  $group          = $::oauth2_proxy::params::group,
  $manage_group   = $::oauth2_proxy::params::manage_group,
  $install_root   = $::oauth2_proxy::params::install_root,
  $manage_service = $::oauth2_proxy::params::manage_service,
  $config,
) inherits oauth2_proxy::params {
  validate_string($user)
  validate_bool($manage_user)
  validate_string($group)
  validate_bool($manage_group)
  validate_absolute_path($install_root)
  validate_bool($manage_service)
  validate_hash($config)

  if $manage_user {
    user { $user:
      gid    => $group,
      system => true,
      home   => '/',
      shell  => '/sbin/nologin',
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
      system => true,
    }
  }

  anchor { '::oauth2_proxy::begin': } ->
    class { '::oauth2_proxy::install': } ~>
      class { '::oauth2_proxy::config': } ->
        anchor { '::oauth2_proxy::end': }

  if $manage_service {
    Class['::oauth2_proxy::config'] ~>
      class { '::oauth2_proxy::service': } ->
        Anchor['::oauth2_proxy::end']
  }
}
