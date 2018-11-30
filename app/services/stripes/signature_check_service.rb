module Stripes
  module SignatureCheckService
    # For more information https://stripe.com/docs/webhooks/signatures
    class << self
      def call(payload, header, secret: Stripes::Configuration.stripe_webhook_secret)
        Stripe::Webhook.construct_event(payload, header, secret)
      rescue Stripe::SignatureVerificationError => e
        raise Stripes::WebhookSignatureError, e.message
      end
    end
  end
end
