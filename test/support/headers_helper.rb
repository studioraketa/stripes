module Stripes
  module HeadersHelper
    def webhook_headers(payload, opts = {})
      {
        'Content-Type' => 'application/json',
        'HTTP_AUTHORIZATION' => baisc_auth,
        'Stripe-Signature' => webhook_signature(payload, opts)
      }
    end

    def baisc_auth
      ActionController::HttpAuthentication::Basic.encode_credentials(
        Configuration.http_basic_auth_user,
        Configuration.http_basic_auth_password
      )
    end

    # Check here https://stripe.com/docs/webhooks/signatures#verify-manually
    # for more information on the signature header.
    def webhook_signature(payload, opts = {})
      opts[:timestamp] ||= Time.now.to_i

      signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        Stripes::Configuration.stripe_webhook_secret,
        "#{opts[:timestamp]}.#{payload}"
      )

      "t=#{opts[:timestamp]},v1=#{signature}"
    end
  end
end
