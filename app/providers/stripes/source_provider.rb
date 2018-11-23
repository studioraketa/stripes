module Stripes
  class SourceProvider
    ::Stripe.api_key = Configuration.stripe_private_key

    class << self
      def create(params)
        return test_create if Rails.env.test?

        live_create(params)
      end

      private

      def live_create(params)
        ::Stripe::Source.create(params)
      rescue ::Stripe::StripeError => e
        raise Stripes::RemoteError.new(e.message, e.class.to_s => e.message)
      end

      def test_create
        OpenStruct.new(id: '1', status: 'pending', 'redirect' => { url: 'test-url' })
      end
    end
  end
end
