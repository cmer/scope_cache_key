# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scope_cache_key/version'

Gem::Specification.new do |gem|
  gem.name          = "scope_cache_key"
  gem.version       = ScopeCacheKey::VERSION
  gem.authors       = ["Carl Mercier"]
  gem.email         = ["carl@carlmercier.com"]
  gem.summary       = %q{Add cache_key functionality to scopes}
  gem.homepage      = "http://github.com/cmer/scope_cache_key"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activerecord', '>= 3.2.12', '>= 3.2.12'

  gem.add_development_dependency('rspec', '~> 2.13.0')
  gem.add_development_dependency('actionpack', '~> 3.2.12')
  gem.add_development_dependency('faker', '~> 1.1.2')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('rake')
end
