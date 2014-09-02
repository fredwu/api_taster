$:.push File.expand_path("../lib", __FILE__)

require "api_taster/version"

Gem::Specification.new do |s|
  s.name        = "api_taster"
  s.version     = ApiTaster::VERSION
  s.authors     = ["Fred Wu", "Mario Chavez"]
  s.email       = ["ifredwu@gmail.com", "mario.chavez@gmail.com"]
  s.homepage    = "https://github.com/fredwu/api_taster"
  s.summary     = "A quick and easy way to visually test out your application's API."
  s.description = s.summary

  s.files      = `git ls-files`.split($\)
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 4.1.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'sass-rails', '~> 4.0.3'
  #s.add_dependency 'bootstrap-sass', '~> 2.1'
  s.add_dependency 'redcarpet'
  s.add_dependency 'remotipart', '~> 1.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec-rails', '~> 2.14.2'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'thin'
end
