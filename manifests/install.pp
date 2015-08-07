# == Class: oauth2_proxy::install
#
# This class should be considered private.
#
class oauth2_proxy::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # XXX the API to this type is confusing.  It is not idempotent unless the
  # resource name matches the subdir created when unpacking the tarball.
  $tarball = 'oauth2_proxy-2.0.1.linux-amd64.go1.4.2'
  archive { $tarball:
    ensure           => present,
    src_target       => $::oauth2_proxy::install_root,
    target           => $::oauth2_proxy::install_root,
    url              => 'https://github.com/bitly/oauth2_proxy/releases/download/v2.0.1/oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz',
    digest_string    => '950e08d52c04104f0539e6945fc42052b30c8d1b',
    digest_type      => 'sha1',
    user             => $::oauth2_proxy::user,
    follow_redirects => true,
    allow_insecure   => false,
    purge_target     => false,
  }

  file { $::oauth2_proxy::install_root:
    ensure => directory,
    owner  => $::oauth2_proxy::user,
    group  => $::oauth2_proxy::group,
    mode   => '0755',
  }

  file { "${::oauth2_proxy::install_root}/bin":
    ensure => link,
    owner  => $::oauth2_proxy::user,
    group  => $::oauth2_proxy::group,
    target => "${::oauth2_proxy::install_root}/${tarball}",
  }
}
