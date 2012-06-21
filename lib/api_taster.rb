require 'active_support/dependencies'
require 'api_taster/engine'
require 'api_taster/route'
require 'api_taster/mapper'
require 'api_taster/form_builder'

module ApiTaster
  def self.routes(&block)
    Route.route_set            = Rails.application.routes
    Route.inputs               = {}
    Route.obsolete_definitions = []
    Mapper.instance_eval(&block)
  end
end
