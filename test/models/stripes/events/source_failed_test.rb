require 'test_helper'

module Stripes
  module Events
    class SourceFailedTest < ActiveSupport::TestCase
      def setup_source
        order = Factory.create(:order)
        payment = Factory.create(:payment, purchase_order: order)
        Factory.create(:source, payment: payment)
      end

      def build_event(source)
        Stripes::Event.new(
          'type' => 'source.failed',
          'data' => {
            'object' => { 'id' => source.identifier }
          }
        )
      end

      test 'updates the charge and payment accordingly' do
        source = setup_source
        event = build_event(source)

        Events::SourceFailed.call(event)

        assert_equal 'failed', source.reload.status
        assert_equal [event.to_h], source.event_log
        assert_equal 'rejected', source.payment.status
      end
    end
  end
end
