require 'test_helper'

module Stripes
  module Events
    class ChargeSucceededTest < ActiveSupport::TestCase
      include ChargesHelper
      include EventsHelper

      test 'updates the charge and payment accordingly' do
        charge = create_charge
        event = build_event('charge.succeeded', charge)

        Events::ChargeSucceeded.call(event)

        assert_equal 'succeeded', charge.reload.status
        assert_equal [event.to_h], charge.event_log
        assert_equal 'paid', charge.payment.status
      end
    end
  end
end
