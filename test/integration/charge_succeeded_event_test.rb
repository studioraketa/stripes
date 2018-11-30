require 'test_helper'

module Stripes
  class ChargeSucceededEventTest < ActionDispatch::IntegrationTest
    include HeadersHelper
    include ChargesHelper
    include EventsHelper

    test 'charge succeeded happy path' do
      charge = create_charge
      event = build_event('charge.succeeded', charge)

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: { 'Content-Type' => 'text/json' }.merge(webhook_headers(event.to_h.to_json))
      )

      assert_response :success

      assert_equal 'succeeded', charge.reload.status
      assert_equal [event.to_h], charge.event_log
      assert_equal 'paid', charge.payment.status
    end
  end
end
