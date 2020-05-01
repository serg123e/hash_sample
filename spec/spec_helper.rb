require 'simplecov'
require 'rspec/simplecov'

SimpleCov.minimum_coverage 100
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'hash_sample'
