module ApiTaster
  class ApplicationController < ActionController::Base
    layout proc { |controller| controller.request.xhr? ? false : 'api_taster/application' }

    before_filter :reload_routes

    private

    def reload_routes
      load Rails.application.root.join('config/routes.rb')
    end
  end
end
