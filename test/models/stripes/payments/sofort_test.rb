require 'test_helper'

module Stripes
  module Payments
    class SofortTest < ActiveSupport::TestCase
      def new_order
        Configuration.order_class.create!(uid: 'ewqefrgdgfn')
      end

      def new_params
        OpenStruct.new(
          type: 'sofort',
          amount: 10,
          currency: 'eur',
          redirect: 'redirect-link',
          country: 'DE',
          preferred_language: 'de',
          statement_descriptor: 'Ble'
        )
      end

      def source_provider
        Struct.new(:name) do
          def create(_params)
            OpenStruct.new(id: '1', status: 'pending', 'redirect' => { url: 'some-cool-url' })
          end
        end.new
      end

      def bad_source_provider
        Struct.new(:name) do
          def create(_params)
            raise ::Stripes::RemoteError.new 'Failure', foo: :bar
          end
        end.new
      end

      def buil_subject(provider)
        Sofort.new(params: new_params, order: new_order, source_provider: provider)
      end

      test 'when remote source creation is a success' do
        subject = buil_subject(source_provider)

        result = subject.create

        assert result.present?
        assert_equal 'some-cool-url', result.redirect_url

        payment = ::Stripes::Payment.last
        source = payment.source

        assert payment.processing?
        assert source.pending?
        assert_equal 10, payment.amount
        assert_equal 'eur', payment.currency
      end

      test 'when remote soource creation fails' do
        subject = buil_subject(bad_source_provider)

        assert_not subject.create

        payment = ::Stripes::Payment.last
        assert payment.rejected?
        assert_equal 10, payment.amount
        assert_equal 'eur', payment.currency
      end

      test '.create happy path' do
        order = new_order

        result = Sofort.create(new_params, order)

        assert result.present?
        assert 'test-url', result.redirect_url

        payment = order.stripes_payment
        source = payment.source

        assert payment.processing?
        assert source.pending?
        assert_equal 10, payment.amount
        assert_equal 'eur', payment.currency
      end
    end
  end
end
