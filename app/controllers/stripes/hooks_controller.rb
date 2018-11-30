module Stripes
  class HooksController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    http_basic_authenticate_with(
      name: Stripes::Configuration.http_basic_auth_user,
      password: Stripes::Configuration.http_basic_auth_password
    )

    def create
      process_event

      head :ok
    rescue Stripes::Error => e
      render json: { message: e.message }, status: :internal_server_error
    end

    private

    def process_event
      payload = request.body.read
      Stripes::SignatureCheckService.call(payload, request.env['HTTP_STRIPE_SIGNATURE'])

      event_hash = JSON.parse(payload)
      Events::Dispatcher.call(Event.new(event_hash))
    end
  end
end
