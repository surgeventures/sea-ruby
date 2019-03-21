lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sea/version'

Gem::Specification.new do |spec|
  spec.name = 'sea'
  spec.version  = Sea::VERSION
  spec.authors  = ['Karol Słuszniak']
  spec.email    = 'karol@shedul.com'
  spec.homepage = 'http://github.com/surgeventures/sea-ruby'
  spec.license  = 'MIT'
  spec.platform = Gem::Platform::RUBY

  spec.summary = 'Side-effect abstraction - signal and observe your side-effects like a pro'

  spec.files            = Dir['lib/**/*.rb']
  spec.has_rdoc         = false
  spec.extra_rdoc_files = ['README.md']
  spec.test_files       = spec.files.grep(%r{^(test)/})
  spec.require_paths    = ['lib']

  spec.add_development_dependency "codecov", "~> 0.1"
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'rubocop', '~> 0.66'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
