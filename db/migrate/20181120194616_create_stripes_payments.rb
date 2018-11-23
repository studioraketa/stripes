class CreateStripesPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :stripes_payments do |t|
      t.integer :payment_type, default: 0, index: true
      t.integer :status, default: 0, index: true
      t.integer :amount, null: false
      t.string :currency, limit: 3, null: false
      t.json :log

      t.timestamps
    end
  end
end
