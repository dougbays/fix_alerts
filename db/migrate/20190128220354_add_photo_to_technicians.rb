class AddPhotoToTechnicians < ActiveRecord::Migration[5.2]
  def change
    add_column :technicians, :photo, :string
  end
end
