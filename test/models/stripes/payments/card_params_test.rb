require 'test_helper'

module Stripes
  module Payments
    class CardParamsTest < ActiveSupport::TestCase
      def buil_subject(params)
        CardParams.new(params)
      end

      def new_params(params = {})
        {
          amount: 10,
          currency: 'eur',
          description: 'Ble',
          source: 'some-random-unique-id',
          email: 'email'
        }.merge(params)
      end

      test 'with all input fields present' do
        subject = buil_subject(new_params)

        assert subject.valid?
      end

      test 'with only required fields present' do
        subject = buil_subject(new_params(email: nil))

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
          buil_subject(new_params(currency: 'ble'))
        end
      end

      test 'with missing description' do
        assert_raise ::Stripes::InvalidParametersError do
          buil_subject(new_params(description: nil))
        end
      end

      test 'with missing source' do
        assert_raise Stripes::InvalidParametersError do
          buil_subject(new_params(source: nil))
        end
      end

      test '#to_h' do
        subject = buil_subject(new_params)
        expected = {
          amount: 10,
          currency: 'eur',
          description: 'Ble',
          source: 'some-random-unique-id',
          receipt_email: 'email'
        }

        assert_equal expected, subject.to_h
      end
    end
  end
end
