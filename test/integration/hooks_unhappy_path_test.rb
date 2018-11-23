require 'test_helper'

module Stripes
  class HooksUnhappyPathTest < ActionDispatch::IntegrationTest
    include LoginHelper
    include EventsHelper

    test 'unsupported event type' do
      event = build_event('source.random', OpenStruct.new(identifier: '123'))

      post(
        '/stripes/hooks',
        params: event.to_h.to_json,
        headers: { 'Content-Type' => 'text/json' }.merge(login_header)
      )

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
  end
end
