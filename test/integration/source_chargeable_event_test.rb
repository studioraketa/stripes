require 'test_helper'

module Stripes
  class SourceFailedEventTest < ActionDispatch::IntegrationTest
    include HeadersHelper
    include SourcesHelper
    include EventsHelper

    test 'source chargeable happy path' do
      source = create_source
      event = build_event('source.chargeable', source)

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: webhook_headers(event.to_h.to_json)
      )

      assert_response :success

      payment = source.payment.reload

      assert_equal 'chargeable', source.reload.status
      assert_equal [event.to_h], source.event_log
      assert_equal 'pending', payment.charge.status
      assert payment.processing?
    end
  end
end
