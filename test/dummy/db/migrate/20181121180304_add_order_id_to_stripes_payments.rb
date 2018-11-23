class AddOrderIdToStripesPayments < ActiveRecord::Migration[5.1]
  def change
    add_reference :stripes_payments, :order, foreign_key: { on_delete: :restrict }
  end
end
