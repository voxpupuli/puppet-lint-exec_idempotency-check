# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-exec_idempotency-check'
  spec.version     = '2.0.0'
  spec.homepage    = 'https://github.com/voxpupuli/puppet-lint-exec_idempotency-check'
  spec.license     = 'Apache-2.0'
  spec.author      = 'Vox Pupuli'
  spec.email       = 'voxpupuli@groups.io'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.summary     = 'A puppet-lint plugin to check the idempotency attributes on exec resources.'
  spec.description = <<-END_DESC
    A puppet-lint plugin to check the idempotency attributes on exec resources.
  END_DESC

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'puppet-lint', '>= 3', '< 5'
  spec.add_development_dependency 'mime-types', '~> 3.4', '>= 3.4.1'
end
