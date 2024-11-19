# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'hash_sample'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sergey Evstegneiev"]
  s.email       = ["serg123e@gmail.com"]
  s.homepage    = 'https://github.com/serg123e/hash_sample'
  s.summary     = 'Implements multiple sampling methods for Hash class'
  s.description = 'Implements methods for Hash class for getting weighted random samples with and without ' \
                  'replacement, as well as regular random samples'

  s.add_development_dependency "codecov", "~> 0.2"
  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "rspec-simplecov", "~> 0.2"
  s.add_development_dependency "simplecov", "~> 0.12"

  s.add_development_dependency "rake", "~> 13"
  s.add_development_dependency "reek", "~> 6"
  s.add_development_dependency "rubocop", "~> 1.59"
  s.add_development_dependency "rubocop-rake", "~> 0.6"
  s.add_development_dependency "rubocop-rspec", "~> 3"
  s.add_development_dependency "yard", "~> 0.9"

  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.4'

  s.date = '2024-11-19'
  s.version = '1.0.1'
  s.license           = 'MIT'

  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md LICENSE]
  # = MANIFEST =
  s.files = %w[
    Gemfile
    LICENSE
    README.md
    Rakefile
    hash_sample.gemspec
    lib/hash_sample.rb
    lib/hash_sample/version.rb
    spec/hash_sample_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =
  s.test_files = s.files.select { |path| path =~ %r{^spec/*\.rb} }
end
