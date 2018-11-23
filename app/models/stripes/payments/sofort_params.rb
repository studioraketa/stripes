module Stripes
  module Payments
    class SofortParams < Stripes::Payments::BaseParams
      ATTRIBUTES = %i[
        amount
        currency
        redirect
        country
        preferred_language
        statement_descriptor
      ].freeze
      COUNTRIES = %w[DE AT BE NL ES IT].freeze
      LANGUAGES = %w[de en es it fr nl pl].freeze

      attr_accessor(*ATTRIBUTES)

      validates :amount, numericality: { only_integer: true, greater_than: 0 }
      validates :currency, inclusion: { in: %w[eur] }
      validates :redirect, presence: true, uri: true
      validates :country, inclusion: { in: COUNTRIES }
      validates :preferred_language, inclusion: { in: LANGUAGES }

      def initialize(params)
        ATTRIBUTES.each { |attr| public_send "#{attr}=", params[attr] }

        raise_error unless valid?
      end

      def to_h
        {
          type: 'sofort',
          amount: amount,
          currency: currency,
          redirect: { return_url: redirect },
          sofort: { country: country, preferred_language: preferred_language },
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
