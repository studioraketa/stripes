class CreateStripesSources < ActiveRecord::Migration[5.1]
  def change
    create_table :stripes_sources do |t|
      t.references :stripes_payment, foreign_key: { on_delete: :restrict }
      t.string :identifier, null: false, limit: 255, index: { unique: true }
      t.string :source_type, default: '', null: false
      t.integer :status, default: 0, null: false, index: true
      t.json :details
      t.json :event_log

      t.timestamps null: false
    end
  end
end
