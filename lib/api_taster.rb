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

  @@controller_hook = nil
  
  # Controller hooking may used for custom filters, authorizations, etc.
  # 
  # Example with adding basic authentication: 
  #     
  #     ApiTaster.controller_hook do
  #       http_basic_authenticate_with name: "admin", password: "123456"
  #     end
  # 
  def self.controller_hook(klass=nil, &block)
    if block_given?
      @@controller_hook = Proc.new {|klass| klass.instance_eval(&block) }
    elsif @@controller_hook && klass
      @@controller_hook.call(klass)
    end
  end
  
  class Exception < ::Exception; end
end
