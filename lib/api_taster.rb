require 'jquery-rails'
require 'bootstrap-sass'
require 'remotipart'
require 'active_support/dependencies'
require 'api_taster/config'
require 'api_taster/engine'
require 'api_taster/route'
require 'api_taster/mapper'
require 'api_taster/form_builder'

module ApiTaster
  mattr_accessor :global_params
  self.global_params = {}

  def self.routes(&block)
    Route.mappings = Proc.new { block }
  end

  class Exception < ::Exception; end
end
