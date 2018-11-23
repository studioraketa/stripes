class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :uid, limit: 100, null: false

      t.timestamps
    end
  end
end
