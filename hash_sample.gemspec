Gem::Specification.new do |s|
    s.name        = 'hash_sample'
    s.platform    = Gem::Platform::RUBY
    s.authors     = ["Sergey Evstegneiev"]
    s.email       = ["serg123e@gmail.com"]
    s.homepage    = 'https://github.com/serg123e/hash_sample'
    s.summary     = %q{Implements multiple sampling methods for Hash class}
    s.description = %q{Implements methods for Hash class for getting weighted random samples with and without replacement, as well as regular random samples}

    s.add_development_dependency "rspec", "~> 3.5"
    s.add_development_dependency "simplecov", "~> 0.12"
    s.add_development_dependency "rspec-simplecov", "~> 0.2"

    s.add_development_dependency "rake", "~> 13"
    s.add_development_dependency "yard", "~> 0.9"


    s.require_paths = ["lib"]

    s.required_ruby_version = '>= 2.4'

    s.date              = '2020-05-01'
    s.version           = '0.8.6'
    s.license           = 'MIT'

    s.rdoc_options = ['--charset=UTF-8']
    s.extra_rdoc_files = %w(README.md LICENSE)
    # = MANIFEST =
    s.files = %w(
      Gemfile
      LICENSE
      README.md
      Rakefile
      hash_sample.gemspec
      lib/hash_sample.rb
      lib/hash_sample/version.rb
      spec/hash_sample_spec.rb
      spec/spec_helper.rb
    )
    # = MANIFEST =
    s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end