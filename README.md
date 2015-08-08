Puppet oauth2_proxy Module
==========================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-oauth2_proxy.png)](https://travis-ci.org/jhoblitt/puppet-oauth2_proxy)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [Examples](#examples)
    * [Classes](#classes)
        * [`oauth2_proxy`](#oauth2_proxy)
4. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
5. [Versioning](#versioning)
6. [Support](#support)
7. [Contributing](#contributing)
8. [See Also](#see-also)


Overview
--------

manages the oauth2_proxy reverse proxy with oauth authentication


Description
-----------

This module installs and configures the
[oauth2_proxy](https://github.com/bitly/oauth2_proxy) package and provides a
minimal systemd service unit.

Log messages [from stdout & stderr] are sent to the systemd journal.  This may
be undesirable with moderate to high volumes of traffic.

Usage
-----

### Examples

```puppet
class { '::oauth2_proxy':
  config => {
    http_address      => '127.0.0.1:4180',
    client_id         => '1234',
    client_secret     => 'abcd',
    github_org        => 'foo',
    upstreams         => [ 'http://127.0.0.1:3000' ],
    cookie_secret     => '1234',
    pass_access_token => false,
    pass_host_header  => true,
    provider          => 'github',
    redirect_url      => 'https://foo.example.org/oauth2/callback',
    email_domains     => [ '*' ],
  }
}
```

### Classes

#### `oauth2_proxy`

```puppet
# defaults
class { '::oauth2_proxy':
  user           => 'oauth2',
  manage_user    => true,
  group          => 'oauth2',
  manage_group   => true,
  install_root   => '/opt/oauth2_proxy',
  manage_service => true,
  config         => { ... }, # mandatory
}
```

##### `user`

`String` defaults to: `oauth2`

The name/uid of the system role account to execute the proxy process under and
will have ownership of files.

##### `manage_user`

`Boolean` defaults to: `true`

Whether or not this module should manage the system role account to execute the
proxy process under.

##### `group`

`String` defaults to: `oauth2`

The group/gid of the system role account and group ownership of files.

##### `manage_group`

`Boolean` defaults to: `true`

Weather or not this module should manage the group of the system role account.

##### `install_root`

`String` defaults to: `/opt/oauth2_proxy`

The dirname under which to install the proxy files.

##### `config`

`Hash` mandatory

A list of key/value pairs to be serialized into a configuration file @
`/etc/oauth2_proxy/oauth2_proxy.conf`.  No validation of this hash is done
beyond checking the parameter type.

The configuration file parameters are similar to the CLI options but have some
variance in terms of name and format.  The
[`oauth2_proxy.cfg.example`](https://github.com/bitly/oauth2_proxy/blob/master/contrib/oauth2_proxy.cfg.example)
provided is the best [only] documentation available beyond the source code
itself.

*Please note that oauth2_proxy does have several mandatory parameters and will
fail to start-up if they are not present.*

Limitations
-----------

### Tested Platforms

* el7

### systemd

This module should in theory be able to function on any `x86_64` Linux
distribution that uses systemd for service management.  However, since this has
not been tested the module is limited to el7/`x86_64`.

Versioning
----------

This module is versioned according to the [Semantic Versioning
2.0.0](http://semver.org/spec/v2.0.0.html) specification.


Support
-------

Please log tickets and issues at
[github](https://github.com/jhoblitt/puppet-oauth2_proxy/issues)


Contributing
------------

1. Fork it on github
2. Make a local clone of your fork
3. Create a topic branch.  Eg, `feature/mousetrap`
4. Make/commit changes
    * Commit messages should be in [imperative tense](http://git-scm.com/book/ch5-2.html)
    * Check that linter warnings or errors are not introduced - `bundle exec rake lint`
    * Check that `Rspec-puppet` unit tests are not broken and coverage is added for new
      features - `bundle exec rake spec`
    * Documentation of API/features is updated as appropriate in the README
    * If present, `beaker` acceptance tests should be run and potentially
      updated - `bundle exec rake beaker`
5. When the feature is complete, rebase / squash the branch history as
   necessary to remove "fix typo", "oops", "whitespace" and other trivial commits
6. Push the topic branch to github
7. Open a Pull Request (PR) from the *topic branch* onto parent repo's `master` branch


See Also
--------

* [oauth2_proxy](https://github.com/bitly/oauth2_proxy)
