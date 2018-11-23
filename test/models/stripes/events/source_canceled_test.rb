require 'test_helper'

module Stripes
  module Events
    class SourceCanceledTest < ActiveSupport::TestCase
      include SourcesHelper
      include EventsHelper

      test 'updates the charge and payment accordingly' do
        source = create_source
        event = build_event('source.canceled', source)

        Events::SourceCanceled.call(event)

        assert_equal 'canceled', source.reload.status
        assert_equal [event.to_h], source.event_log
        assert_equal 'rejected', source.payment.status
      end
    end
  end
end
