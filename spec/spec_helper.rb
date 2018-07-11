$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'bundler'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require 'playlist'

def fixture_path(name)
  File.join(__dir__, 'fixtures', name.to_s)
end

def fixture(name)
  File.read(fixture_path(name))
end
