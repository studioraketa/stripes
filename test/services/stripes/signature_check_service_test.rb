require 'test_helper'

module Stripes
  class SignatureCheckServiceTest < ActiveSupport::TestCase
    def sign(payload, timestamp, secret)
      signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        secret,
        "#{timestamp}.#{payload}"
      )

      "t=#{timestamp},v1=#{signature}"
    end

    def payload
      { foo: 'bar' }
    end

    test 'happy path' do
      timestamp = Time.now.to_i
      signature = sign(payload.to_json, timestamp, 'secret')

      assert_nothing_raised do
        SignatureCheckService.call(payload.to_json, signature, secret: 'secret')
      end
    end

    test 'when the signing secrets are different' do
      timestamp = Time.now.to_i
      signature = sign(payload.to_json, timestamp, 'super-secret')

      assert_raises Stripes::WebhookSignatureError do
        SignatureCheckService.call(payload.to_json, signature, secret: 'secret')
      end
    end

    test 'when the time stamp is more than 5 minutes old' do
      timestamp = (Time.now - 5.minutes - 1.second).to_i
      signature = sign(payload.to_json, timestamp, 'secret')

      assert_raises Stripes::WebhookSignatureError do
        SignatureCheckService.call(payload.to_json, signature, secret: 'secret')
      end
    end
  end
end
