class CreateTechnicians < ActiveRecord::Migration[5.2]
  def change
    create_table :technicians do |t|
      t.references :user, foreign_key: true
      t.text :description
      t.string :picture

      t.timestamps
    end
  end
end
