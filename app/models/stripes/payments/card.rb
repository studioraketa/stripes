module Stripes
  module Payments
    class Card
      class << self
        def create(options, order)
          new(
            charge_provider: ::Stripes::ChargeProvider,
            params: ::Stripes::Payments::CardParams.new(options),
            order: order
          ).create
        end
      end

      def initialize(params:, charge_provider:, order:)
        @charge_provider = charge_provider
        @params = params
        @order = order
      end

      def create
        payment = create_payment
        remote_charge = create_remote_charge
        create_local_charge(payment, remote_charge)
        update_payment_state(payment, remote_charge)

        remote_charge.status == 'succeeded'
      rescue ::Stripes::RemoteError => e
        payment.update!(
          log: Array(payment.log) << e.details,
          status: :rejected
        )
        false
      end

      private

      def update_payment_state(payment, charge)
        payment_state = charge.status == 'succeeded' ? :paid : :rejected

        payment.update!(status: payment_state)
      end

      def create_payment
        ::Stripes::Payment.create!(
          purchase_order: @order,
          payment_type: :card,
          status: :pending,
          amount: @params.amount,
          currency: @params.currency,
          log: []
        )
      end

      def create_local_charge(payment, remove_charge)
        ::Stripes::Charge.create!(
          payment: payment,
          status: remove_charge.status,
          identifier: remove_charge.id,
          details: remove_charge.to_h,
          event_log: []
        )
      end

      def create_remote_charge
        @charge_provider.create(@params.to_h)
      end
    end
  end
end
