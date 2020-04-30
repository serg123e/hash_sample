Gem::Specification.new do |s|
    s.name        = 'hash_sample'
    s.platform    = Gem::Platform::RUBY
    s.authors     = ["Sergey Evstegneiev"]
    s.email       = ["serg123e@gmail.com"]
    s.homepage    = 'https://github.com/serg123e/hash-sample'
    s.summary     = %q{Implements multiple sampling methods for Hash class}
    s.description = %q{Regular and weighted random sampling with and without replacement are implemented}
    s.metadata    = { 'source_code_uri' => 'https://github.com/serg123e/hash-sample' }
    s.add_development_dependency "rspec", "~> 3.5"
    s.add_development_dependency "rake", "~> 13"

    s.require_paths = ["lib"]

    s.required_ruby_version = '>= 2.4'

    s.date              = '2020-05-01'
    s.version           = '0.8.4'
    s.license           = 'MIT'

    s.rdoc_options = ['--charset=UTF-8']
    s.extra_rdoc_files = %w(README.md LICENSE)
    # = MANIFEST =
    s.files = %w(
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