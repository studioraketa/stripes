require 'test_helper'

module Stripes
  module Events
    class SourceChargeableTest < ActiveSupport::TestCase
      include SourcesHelper
      include EventsHelper

      def charge_provider
        Struct.new(:name) do
          def create(_params)
            OpenStruct.new(id: '1', status: 'succeeded')
          end
        end.new
      end

      def bad_charge_provider
        Struct.new(:name) do
          def create(_params)
            raise Stripes::RemoteError.new 'Failure', foo: :bar
          end
        end.new
      end

      def build_subject(event, source, charge_provider)
        Events::SourceChargeable.new(
          event: event,
          charge_provider: charge_provider,
          source: source
        )
      end

      test 'on remote success creates a charge' do
        source = create_source
        event = build_event('source.chargeable', source)
        subject = build_subject(event, source, charge_provider)

        subject.call

        payment = source.payment

        assert_equal 'chargeable', source.reload.status
        assert_equal [event.to_h], source.event_log
        assert_equal 'pending', payment.charge.status
        assert payment.processing?
      end

      test 'on a second call updates only the log' do
        source = create_source
        event = build_event('source.chargeable', source)
        subject = build_subject(event, source, charge_provider)

        subject.call

        payment = source.payment

        assert_equal 'chargeable', source.reload.status
        assert_equal [event.to_h], source.event_log
        assert_equal 'pending', payment.charge.status
        assert payment.processing?

        subject = build_subject(event, source, charge_provider)

        subject.call

        assert_equal 'chargeable', source.reload.status
        assert_equal [event.to_h, event.to_h], source.event_log
        assert_equal 'pending', payment.charge.status
        assert payment.processing?
      end

      test 'on remote charge failure raises an error' do
        source = create_source
        event = build_event('source.chargeable', source)
        subject = build_subject(event, source, bad_charge_provider)

        assert_raise Stripes::RemoteError do
          subject.call
        end

        assert_equal 'pending', source.reload.status
        assert_not source.payment.charge
        assert source.event_log.include?('foo' => 'bar')
      end
    end
  end
end
