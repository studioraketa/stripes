require 'test_helper'

module Stripes
  module Events
    class ChargePendingTest < ActiveSupport::TestCase
      include ChargesHelper
      include EventsHelper

      test 'logs the event if the charge is pending' do
        charge = create_charge
        event = build_event('charge.pending', charge)

        Events::ChargePending.call(event)

        assert_equal 'pending', charge.reload.status
        assert_equal [event.to_h], charge.event_log
        assert_equal 'pending', charge.payment.status
      end

      test 'logs the event if the charge is not pending' do
        charge = create_charge(
          charge_params: { status: :succeeded },
          payment_params: { status: :paid }
        )
        event = build_event('charge.pending', charge)

        Events::ChargePending.call(event)

        assert_equal 'succeeded', charge.reload.status
        assert_equal [event.to_h], charge.event_log
        assert_equal 'paid', charge.payment.status
      end
    end
  end
end
