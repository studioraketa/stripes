require 'test_helper'

module Stripes
  class ChargeFailedEventTest < ActionDispatch::IntegrationTest
    include LoginHelper
    include ChargesHelper
    include EventsHelper

    test 'charge failed happy path' do
      charge = create_charge
      event = build_event('charge.failed', charge)

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: { 'Content-Type' => 'text/json' }.merge(login_header)
      )

      assert_response :success

      assert_equal 'failed', charge.reload.status
      assert_equal [event.to_h], charge.event_log
      assert_equal 'rejected', charge.payment.status
    end
  end
end
