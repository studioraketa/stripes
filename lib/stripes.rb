require 'stripes/engine'
require 'stripe'

module Stripes
  class << self
    def card_payment(params, order)
      Stripes::Payments::Card.create(params, order)
    end

    def sofort_payment(params, order)
      Stripes::Payments::Sofort.create(params, order)
    end

    def sofort_countries
      Stripes::Payments::SofortParams::COUNTRIES
    end

    def sofort_languages
      Stripes::Payments::SofortParams::LANGUAGES
    end

    def giropay(params, order)
      Stripes::Payments::Giropay.create(params, order)
    end
  end

  class Configuration
    ATTRIBUTES = %i[
      order_class
      order_table_foreign_key
      http_basic_auth_user
      http_basic_auth_password
      stripe_public_key
      stripe_private_key
      stripe_webhook_secret
    ].freeze

    class_attribute(*ATTRIBUTES)

    class << self
      def configure
        yield self
      end
    end
  end
end
