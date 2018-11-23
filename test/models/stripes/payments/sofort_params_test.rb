require 'test_helper'

module Stripes
  module Payments
    class SofortPaymentParamsTest < ActiveSupport::TestCase
      def buil_subject(params)
        SofortParams.new(params)
      end

      def new_params(params = {})
        {
          amount: 10,
          currency: 'eur',
          redirect: 'https://www.google.com',
          country: 'DE',
          preferred_language: 'de',
          statement_descriptor: 'Some description here.'
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
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(amount: -1))
        end
      end

      test 'with invalid amount' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(amount: 'abc'))
        end
      end

      test 'with invalid currency' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(currency: 'usd'))
        end
      end

      test 'with missing redirect' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(redirect: nil))
        end
      end

      test 'with invalid redirect protocol' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(redirect: 'httt://www.google.com'))
        end
      end

      test 'with invalid country' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(country: 'GB'))
        end
      end

      test 'with invalid preferred_language' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(preferred_language: 'cn'))
        end
      end

      test '#to_h' do
        subject = buil_subject(new_params)
        expected = {
          type: 'sofort',
          amount: 10,
          currency: 'eur',
          redirect: { return_url: 'https://www.google.com' },
          sofort: { country: 'DE', preferred_language: 'de' },
          statement_descriptor: 'Some description here.'
        }

        assert_equal expected, subject.to_h
      end
    end
  end
end
