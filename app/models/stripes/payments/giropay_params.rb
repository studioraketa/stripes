module Stripes
  module Payments
    class GiropayParams < Stripes::Payments::BaseParams
      ATTRIBUTES = %i[
        amount
        currency
        name
        redirect
        statement_descriptor
      ].freeze

      attr_accessor(*ATTRIBUTES)

      validates :currency, inclusion: { in: %w[eur] }
      validates :amount, numericality: { only_integer: true, greater_than: 0 }
      validates :name, presence: true
      validates :redirect, presence: true, uri: true

      def initialize(params)
        ATTRIBUTES.each { |attr| public_send "#{attr}=", params[attr] }

        raise_error unless valid?
      end

      def to_h
        {
          type: 'giropay',
          amount: amount,
          currency: currency,
          owner: { name: name },
          redirect: { return_url: redirect },
          statement_descriptor: statement_descriptor
        }.compact
      end

      private

      def raise_error
        raise ::Stripes::InvalidParametersError, errors.full_messages.to_sentence
      end
    end
  end
end
