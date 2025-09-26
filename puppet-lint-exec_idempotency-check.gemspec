# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-exec_idempotency-check'
  spec.version     = '2.0.0'
  spec.homepage    = 'https://github.com/voxpupuli/puppet-lint-exec_idempotency-check'
  spec.license     = 'GPL-3.0-only'
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

  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'puppet-lint', '~> 5.1'
  spec.add_development_dependency 'mime-types', '~> 3.4', '>= 3.4.1'
end
