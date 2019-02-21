class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.references :client, foreign_key: true
      t.references :technician, foreign_key: true
      t.integer :price_estimate
      t.date :date
      t.time :time
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
