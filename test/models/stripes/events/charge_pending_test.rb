require 'test_helper'

module Stripes
  module Events
    class ChargePendingTest < ActiveSupport::TestCase
      include ChargesHelper
      include EventsHelper

      test 'updates the charge and payment accordingly' do
        charge = create_charge
        event = build_event('charge.pending', charge)

        Events::ChargePending.call(event)

        assert_equal 'pending', charge.reload.status
        assert_equal [event.to_h], charge.event_log
        assert_equal 'pending', charge.payment.status
      end
    end
  end
end
