module Stripes
  class HooksController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    http_basic_authenticate_with name: 'user', password: 'secret'

    def create
      event_hash = JSON.parse(request.body.read)
      Events::Dispatcher.call(Event.new(event_hash))
      head :ok
    rescue Stripes::Error => e
      render json: { message: e.message }, status: :internal_server_error
    end
  end
end
