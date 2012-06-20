require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../spec/dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'pry'

require File.expand_path('../../lib/api_taster', __FILE__)
Dir[ApiTaster::Engine.root.join('spec/support/**/*.rb', __FILE__)].each {|f| require f}
