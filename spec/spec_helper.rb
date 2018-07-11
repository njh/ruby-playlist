$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)

SimpleCov.start

require 'playlist'

def fixture_path(name)
  File.join(__dir__, 'fixtures', name.to_s)
end

def fixture(name)
  File.read(fixture_path(name))
end
