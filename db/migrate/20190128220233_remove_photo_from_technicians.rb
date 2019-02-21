class RemovePhotoFromTechnicians < ActiveRecord::Migration[5.2]
  def change
    remove_column :technicians, :photo, :string
  end
end
