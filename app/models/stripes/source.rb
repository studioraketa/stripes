module Stripes
  class Source < ApplicationRecord
    belongs_to(
      :payment,
      class_name: 'Stripes::Payment',
      foreign_key: :stripes_payment_id,
      inverse_of: :source
    )

    enum status: { pending: 0, chargeable: 1, consumed: 2, failed: 3, canceled: 4 }

    def redirect_url
      details.dig('redirect', 'url')
    end
  end
end
