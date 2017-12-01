# == Class: oauth2_proxy
#
class oauth2_proxy(
  $user           = $::oauth2_proxy::params::user,
  $manage_user    = $::oauth2_proxy::params::manage_user,
  $group          = $::oauth2_proxy::params::group,
  $manage_group   = $::oauth2_proxy::params::manage_group,
  $install_root   = $::oauth2_proxy::params::install_root,
  $manage_install = $::oauth2_proxy::params::manage_install,
  $source         = $::oauth2_proxy::params::source,
  $checksum       = $::oauth2_proxy::params::checksum,
  $systemd_path   = $::oauth2_proxy::params::systemd_path,
  $shell          = $::oauth2_proxy::params::shell,
  $provider       = $::oauth2_proxy::params::provider,
  $command_path   = $::oauth2_proxy::params::command_path,
  $config_dir     = $::oauth2_proxy::params::config_dir,
  $data_dir       = $::oauth2_proxy::params::data_dir,
  $log_dir        = $::oauth2_proxy::params::log_dir,
) inherits oauth2_proxy::params {
  validate_string($user)
  validate_bool($manage_user)
  validate_string($group)
  validate_bool($manage_group)
  validate_absolute_path($install_root)
  validate_bool($manage_install)
  validate_string($source)
  validate_string($checksum)
  validate_absolute_path($systemd_path)
  validate_absolute_path($shell)
  validate_absolute_path($command_path)
  validate_absolute_path($config_dir)
  validate_absolute_path($data_dir)
  validate_absolute_path($log_dir)

  if $manage_user {
    user { $user:
      gid    => $group,
      system => true,
      home   => '/',
      shell  => $shell,
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
      system => true,
    }
  }

  anchor { '::oauth2_proxy::begin': }
    -> class { '::oauth2_proxy::install': }
      ~> Oauth2_proxy::Instance<| |>
        -> anchor { '::oauth2_proxy::end': }
}
