module Stripes
  module Events
    class SourceChargeable
      class << self
        def call(event)
          new(
            event: event,
            source: ::Stripes::Source.find_by!(identifier: event.obj_id),
            charge_provider: ::Stripes::ChargeProvider
          ).call
        end
      end

      def initialize(event:, source:, charge_provider:)
        raise 'Wrong event type' unless event.type == 'source.chargeable'

        @event = event
        @source = source
        @charge_provider = charge_provider
      end

      # Charges are created only for pending sources.
      # If the state is different a charge MUST NOT be created!
      def call
        source.pending? ? execute_charging : log_event(event.to_h)
      rescue Stripes::RemoteError => e
        log_event(e.details)

        raise
      end

      private

      attr_reader :source, :event

      def execute_charging
        source.with_lock do
          update_source
          source.payment.update!(status: :processing)
          charge = create_charge
          persist_charge(source, charge)
        end
      end

      def update_source
        source.status = :chargeable
        source.event_log = Array(source.event_log) << event.to_h
        source.save!
      end

      def create_charge
        @charge_provider.create(
          amount: source.payment.amount,
          currency: source.payment.currency,
          source: source.identifier
        )
      end

      def persist_charge(source, remote_charge)
        ::Stripes::Charge.create!(
          payment: source.payment,
          status: :pending,
          identifier: remote_charge.id,
          details: remote_charge.to_h,
          source_uid: source.identifier,
          event_log: []
        )
      end

      def log_event(data)
        source.event_log = Array(source.event_log) << data
        source.save!
      end
    end
  end
end
