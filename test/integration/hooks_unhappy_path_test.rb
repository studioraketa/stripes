require 'test_helper'

module Stripes
  class HooksUnhappyPathTest < ActionDispatch::IntegrationTest
    include HeadersHelper
    include EventsHelper

    test 'unsupported event type' do
      event = build_event('source.random', OpenStruct.new(identifier: '123'))

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: webhook_headers(event.to_h.to_json)
      )

      assert response.body.include?('Unknown event type source.random')
      assert_response 500
    end

    test 'unauthorised request' do
      post(
        '/stripes/hooks',
        params: { foo: 'bar' },
        headers: { 'Content-Type' => 'text/json' }
      )

      assert_response 401
    end

    test 'no signature header' do
      event = build_event('source.random', OpenStruct.new(identifier: '123'))

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'HTTP_AUTHORIZATION' => baisc_auth,
        }
      )

      assert_response 500
      assert response.body.include?('Unable to extract timestamp and signatures from header')
    end
  end
end
