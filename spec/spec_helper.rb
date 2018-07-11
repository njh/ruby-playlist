$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)

SimpleCov.start

require 'playlist'
