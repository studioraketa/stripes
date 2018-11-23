require 'test_helper'

module Stripes
  module Payments
    class CardTest < ActiveSupport::TestCase
      def new_order
        Configuration.order_class.create!(uid: 'ewqefrgdgfn')
      end

      def new_params
        OpenStruct.new(
          amount: 10,
          currency: 'eur',
          description: 'Ble',
          source: 'some-random-unique-id',
          email: 'email'
        )
      end

      def charge_provider
        Struct.new(:name) do
          def create(_params)
            OpenStruct.new(id: '1', status: 'succeeded')
          end
        end.new
      end

      def bad_charge_provider
        Struct.new(:name) do
          def create(_params)
            raise ::Stripes::RemoteError.new 'Failure', foo: :bar
          end
        end.new
      end

      def buil_subject(provider)
        Card.new(params: new_params, order: new_order, charge_provider: provider)
      end

      test 'when remote charge creation is a success' do
        subject = buil_subject(charge_provider)

        assert subject.create

        payment = ::Stripes::Payment.last
        charge = payment.charge

        assert payment.paid?
        assert charge.succeeded?
        assert_equal 10, payment.amount
        assert_equal 'eur', payment.currency
      end

      test 'when remote charge creation fails' do
        subject = buil_subject(bad_charge_provider)

        assert_not subject.create

        payment = ::Stripes::Payment.last
        assert payment.rejected?
        assert_equal 10, payment.amount
        assert_equal 'eur', payment.currency
      end

      test '.create happy path' do
        order = new_order

        Card.create(new_params, order)

        payment = order.stripes_payment
        charge = payment.charge

        assert payment.paid?
        assert charge.succeeded?
        assert_equal 10, payment.amount
        assert_equal 'eur', payment.currency
      end
    end
  end
end