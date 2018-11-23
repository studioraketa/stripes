require 'test_helper'

module Stripes
  module Payments
    class GiropayParamsTest < ActiveSupport::TestCase
      def buil_subject(params)
        GiropayParams.new(params)
      end

      def new_params(params = {})
        {
          amount: 10,
          currency: 'eur',
          name: 'Peter Parker',
          redirect: 'www.google.com',
          statement_descriptor: 'some description'
        }.merge(params)
      end

      test 'with all input fields present' do
        subject = buil_subject(new_params)

        assert subject.valid?
      end

      test 'with only required fields present' do
        subject = buil_subject(new_params(statement_descriptor: nil))

        assert subject.valid?
      end

      test 'with negative amount' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(amount: -1))
        end
      end

      test 'with invalid amount' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(amount: 'abc'))
        end
      end

      test 'with invalid currency' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(currency: 'ble'))
        end
      end

      test 'with unallowed currency' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(currency: 'usd'))
        end
      end

      test 'with missing name' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(name: nil))
        end
      end

      test 'with invalid redirect' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(redirect: ''))
        end
      end

      test '#to_h' do
        subject = buil_subject(new_params)
        expected = {
          type: 'giropay',
          amount: 10,
          currency: 'eur',
          owner: { name: 'Peter Parker' },
          redirect: { return_url: 'www.google.com' },
          statement_descriptor: 'some description'
        }

        assert_equal expected, subject.to_h
      end
    end
  end
end
