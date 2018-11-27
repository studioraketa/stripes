require 'test_helper'

module Stripes
  module Events
    class SourceFailedTest < ActiveSupport::TestCase
      include SourcesHelper
      include EventsHelper

      test 'updates a pending charge its and payment accordingly' do
        source = create_source
        event = build_event('source.failed', source)

        Events::SourceFailed.call(event)

        assert_equal 'failed', source.reload.status
        assert_equal [event.to_h], source.event_log
        assert_equal 'rejected', source.payment.status
      end

      test 'logs the event if the source is not pending' do
        source = create_source(
          source_params: { status: :chargeable },
          payment_params: { status: :processing }
        )
        event = build_event('source.failed', source)

        Events::SourceFailed.call(event)

        assert_equal 'chargeable', source.reload.status
        assert_equal [event.to_h], source.event_log
        assert_equal 'processing', source.payment.status
      end
    end
  end
end
