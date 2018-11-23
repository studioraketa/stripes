module Stripes
  class ChargeProvider
    ::Stripe.api_key = Configuration.stripe_private_key

    class << self
      def create(params)
        return test_create if Rails.env.test?

        live_create(params)
      end

      private

      def live_create(params)
        ::Stripe::Charge.create(params)
      rescue ::Stripe::StripeError => e
        raise Stripes::RemoteError.new(e.message, e.class.to_s => e.message)
      end

      def test_create
        OpenStruct.new status: 'succeeded', id: SecureRandom.uuid
      end
    end
  end
end
