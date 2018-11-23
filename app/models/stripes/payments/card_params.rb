module Stripes
  module Payments
    class CardParams < Stripes::Payments::BaseParams
      ATTRIBUTES = %i[
        amount
        currency
        description
        source
        email
      ].freeze

      attr_accessor(*ATTRIBUTES)

      validates :source, presence: true
      validates :description, presence: true
      # TODO: Extract currencies in a single source of truth.
      validates :currency, inclusion: { in: %w[eur usd] }
      validates :amount, numericality: { only_integer: true, greater_than: 0 }

      def initialize(params)
        ATTRIBUTES.each { |attr| public_send "#{attr}=", params[attr] }

        raise_error unless valid?
      end

      def to_h
        {
          amount: amount,
          currency: currency,
          description: description,
          source: source,
          receipt_email: email
        }.compact
      end

      private

      def raise_error
        raise ::Stripes::InvalidParametersError, errors.full_messages.to_sentence
      end
    end
  end
end
