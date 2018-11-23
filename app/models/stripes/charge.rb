module Stripes
  class Charge < ApplicationRecord
    belongs_to(
      :payment,
      class_name: 'Stripes::Payment',
      foreign_key: :stripes_payment_id,
      inverse_of: :charge
    )

    enum status: { pending: 0, succeeded: 1, failed: 2 }
  end
end
