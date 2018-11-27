require 'test_helper'

module Stripes
  module Events
    class ChargeFailedTest < ActiveSupport::TestCase
      include ChargesHelper
      include EventsHelper

      test 'updates a pending charge and its payment accordingly' do
        charge = create_charge
        event = build_event('charge.failed', charge)

        Events::ChargeFailed.call(event)

        assert_equal 'failed', charge.reload.status
        assert_equal [event.to_h], charge.event_log
        assert_equal 'rejected', charge.payment.status
      end

      test 'logs the event if the charge is not pending' do
        charge = create_charge(
          charge_params: { status: :succeeded },
          payment_params: { status: :paid }
        )
        event = build_event('charge.failed', charge)

        Events::ChargeFailed.call(event)

        assert_equal 'succeeded', charge.reload.status
        assert_equal [event.to_h], charge.event_log
        assert_equal 'paid', charge.payment.status
      end
    end
  end
end
