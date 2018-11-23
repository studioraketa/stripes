module Stripes
  module Payments
    class Sofort
      class << self
        def create(options, order)
          new(
            source_provider: ::Stripes::SourceProvider,
            params: ::Stripes::Payments::SofortParams.new(options),
            order: order
          ).create
        end
      end

      def initialize(params:, source_provider:, order:)
        @source_provider = source_provider
        @params = params
        @order = order
      end

      def create
        payment = create_payment
        remote_source = create_remote_source
        local_source = create_local_source(payment, remote_source)
        update_payment_state(payment, remote_source)

        local_source if remote_source.status == 'pending'
      rescue ::Stripes::RemoteError => e
        payment.update!(
          log: Array(payment.log) << e.details,
          status: :rejected
        )
        nil
      end

      private

      def update_payment_state(payment, source)
        payment_state = source.status == 'pending' ? :processing : :rejected

        payment.update!(status: payment_state)
      end

      def create_payment
        ::Stripes::Payment.create!(
          purchase_order: @order,
          payment_type: :sofort,
          status: :pending,
          amount: @params.amount,
          currency: @params.currency,
          log: []
        )
      end

      def create_local_source(payment, remove_charge)
        ::Stripes::Source.create!(
          payment: payment,
          source_type: 'sofort',
          status: :pending,
          identifier: remove_charge.id,
          details: remove_charge.to_h,
          event_log: []
        )
      end

      def create_remote_source
        @source_provider.create(@params.to_h)
      end
    end
  end
end
