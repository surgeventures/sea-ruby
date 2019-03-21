require 'simplecov'
SimpleCov.start

if ENV.key?("CODECOV_TOKEN")
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'minitest/autorun'
require 'sea'

