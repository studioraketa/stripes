class CreateStripesCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :stripes_charges do |t|
      t.references :stripes_payment, foreign_key: { on_delete: :restrict }
      t.string :identifier, null: false, limit: 255, index: { unique: true }
      t.integer :status, default: 0, null: false, index: true
      t.string :source_uid
      t.json :details
      t.json :event_log

      t.timestamps null: false
    end
  end
end
