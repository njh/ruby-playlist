$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'playlist/version'

Gem::Specification.new do |spec|
  spec.name          = 'playlist'
  spec.version       = Playlist::VERSION
  spec.authors       = ['Nicholas Humfrey']
  spec.email         = ['njh@aelius.com']

  spec.summary       = 'Convert playlists between different formats'
  spec.homepage      = 'https://github.com/njh/ruby-playlist'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler',        '> 1.13'
  spec.add_development_dependency 'equivalent-xml', '~> 0.6.0'
  spec.add_development_dependency 'rake',           '~> 10.2.2'
  spec.add_development_dependency 'rspec',          '~> 3.7.0'
  spec.add_development_dependency 'rubocop',        '~> 0.50.0'
  spec.add_development_dependency 'simplecov',      '~> 0.9.2'
  spec.add_development_dependency 'yard',           '~> 0.9.14'
end
