# == Class: oauth2_proxy
#
class oauth2_proxy(
  $user         = $::oauth2_proxy::params::user,
  $manage_user  = $::oauth2_proxy::params::manage_user,
  $group        = $::oauth2_proxy::params::group,
  $manage_group = $::oauth2_proxy::params::manage_group,
  $install_root = $::oauth2_proxy::params::install_root,
  $source       = $::oauth2_proxy::params::source,
  $checksum     = $::oauth2_proxy::params::checksum,
  $systemd_path = $::oauth2_proxy::params::systemd_path,
  $user_shell   = $::oauth2_proxy::params::user_shell,
  $provider     = $::oauth2_proxy::params::provider,
) inherits oauth2_proxy::params {
  validate_string($user)
  validate_bool($manage_user)
  validate_string($group)
  validate_bool($manage_group)
  validate_absolute_path($install_root)
  validate_string($source)
  validate_string($checksum)
  validate_absolute_path($systemd_path)
  validate_absolute_path($user_shell)

  $user_shell = $::osfamily ? {
    'Redhat' => '/sbin/nologin',
    'Debian' => '/bin/false',
  }

  if $manage_user {
    user { $user:
      gid    => $group,
      system => true,
      home   => '/',
      shell  => $user_shell,
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
    Oauth2_proxy::Instance<| |> ->
      anchor { '::oauth2_proxy::end': }
}
