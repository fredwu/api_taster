require 'active_support/configurable'

module ApiTaster
  # Configures global settings for ApiTaster
  #   ApiTaster.configure do |config|
  #     config.title = 'My Application Name'
  #   end
  def self.configure(&block)
    yield @config ||= ApiTaster::Configuration.new
  end

  # Global settings for ApiTaster
  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor :title
    config_accessor :call_to_action
    config_accessor :app_title
    config_accessor :app_url
    config_accessor :include_missing_definitions
    config_accessor :include_obsolete_definitions

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def param_name=(value); config.param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line
  end

  configure do |config|
    config.title = 'API Taster'
    config.call_to_action = 'Select an API endpoint on the left to get started. :)'
    config.app_title = 'Application'
    config.app_url = '/'
    config.include_missing_definitions = true
    config.include_obsolete_definitions = true
  end
end
