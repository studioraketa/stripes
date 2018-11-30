require 'test_helper'

module Stripes
  class SourceFailedEventTest < ActionDispatch::IntegrationTest
    include HeadersHelper
    include SourcesHelper
    include EventsHelper

    test 'source failed happy path' do
      source = create_source
      event = build_event('source.failed', source)

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: webhook_headers(event.to_h.to_json)
      )

      assert_response :success

      assert_equal 'failed', source.reload.status
      assert_equal [event.to_h], source.event_log
      assert_equal 'rejected', source.payment.status
    end
  end
end
