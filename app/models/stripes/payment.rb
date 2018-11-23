module Stripes
  class Payment < ApplicationRecord
    belongs_to(
      :purchase_order,
      class_name: Configuration.order_class.to_s,
      foreign_key: Configuration.order_table_foreign_key,
      inverse_of: :stripes_payment
    )

    has_one(
      :charge,
      class_name: 'Stripes::Charge',
      foreign_key: :stripes_payment_id,
      dependent: :restrict_with_error,
      inverse_of: :payment
    )

    has_one(
      :source,
      class_name: 'Stripes::Source',
      foreign_key: :stripes_payment_id,
      dependent: :restrict_with_error,
      inverse_of: :payment
    )

    enum payment_type: { card: 0, bank: 1, sofort: 2 }
    enum status: { pending: 0, processing: 1, paid: 2, rejected: 3 }
  end
end
