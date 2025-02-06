puppet-lint-exec_idempotency-check
==============================

[![License](https://img.shields.io/github/license/voxpupuli/puppet-lint-exec_idempotency-check.svg)](https://github.com/voxpupuli/puppet-lint-exec_idempotency-check/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/puppet-lint-exec_idempotency-check/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/puppet-lint-exec_idempotency-check/actions/workflows/test.yml)
[![Release](https://github.com/voxpupuli/puppet-lint-exec_idempotency-check/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-lint-exec_idempotency-check/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/puppet-lint-exec_idempotency-check.svg)](https://rubygems.org/gems/puppet-lint-exec_idempotency-check)
[![RubyGem Downloads](https://img.shields.io/gem/dt/puppet-lint-exec_idempotency-check.svg)](https://rubygems.org/gems/puppet-lint-exec_idempotency-check)
[![codecov](https://codecov.io/gh/voxpupuli/puppet-lint-exec_idempotency-check/branch/master/graph/badge.svg)](https://codecov.io/gh/voxpupuli/puppet-lint-exec_idempotency-check)

A puppet-lint plugin to check the idempotency attributes on exec resources.

## Installing

### From the command line

```shell
$ gem install puppet-lint-exec_idempotency-check
```

### In a Gemfile

```ruby
gem 'puppet-lint-exec_idempotency-check', :require => false
```

## Checks

### Ensure idempotency attributes are set on exec resource

When using `exec` resource it is highly recommended to take care on idempotency. That means, that we need a check to verify if the command should be run again or is required to run at all.

The following attributes control this behavior:

- `creates`: checks if a directory or file exists
- `onlyif` or `unless`: execute checks to verify idempotency
- `refreshonly`: only run the exec if it is triggered by another reosurce

#### What you have done

```puppet
exec { '/bin/apt update':
}
```

#### What you should have done

```puppet
exec { '/bin/apt update':
  refreshonly => true,
}
```

#### Disabling the check

To disable this check, you can add `--no-exec_idempotency-check` to your puppet-lint command line.

```shell
$ puppet-lint --no-exec_idempotency-check path/to/file.pp
```

Alternatively, if you’re calling puppet-lint via the Rake task, you should insert the following line to your `Rakefile`.

```ruby
PuppetLint.configuration.send('disable_exec_idempotency')
```

## License

This gem is licensed under the Apache-2 license.

## Release information

To make a new release, please do:
* update the version in the gemspec file
* Install gems with `bundle install --with release --path .vendor`
* generate the changelog with `bundle exec rake changelog`
* Check if the new version matches the closed issues/PRs in the changelog
* Create a PR with it
* After it got merged, push a tag. GitHub actions will do the actual release to rubygems and GitHub Packages
