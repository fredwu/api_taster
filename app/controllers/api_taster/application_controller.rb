module ApiTaster
  class ApplicationController < ActionController::Base
    layout proc { |controller| controller.request.xhr? ? nil : 'api_taster/application' }
  end
end
