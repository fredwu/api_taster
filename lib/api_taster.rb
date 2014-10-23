require 'jquery-rails'
require 'remotipart'
require 'active_support/dependencies'
require 'api_taster/engine'
require 'api_taster/route'
require 'api_taster/mapper'
require 'api_taster/form_builder'
require 'api_taster/route_collector'

module ApiTaster
  mattr_accessor :global_params
  self.global_params = {}

  mattr_accessor :route_path
  def self.route_path
    @@route_path ||= begin
      "#{Rails.root.to_s}/lib/api_tasters"
    end
  end

  mattr_accessor :global_headers
  self.global_headers = {}

  def self.routes(&block)
    ApiTaster::RouteCollector.routes << block
  end

  class Exception < ::Exception; end
end
