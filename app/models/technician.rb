class Technician < ApplicationRecord
  belongs_to :user
  has_many :appointments, dependent: :destroy
  has_many :specialties, dependent: :destroy
  has_many :categories, through: :specialties

  mount_uploader :photo, PhotoUploader

  def categories
    categories_names = []
    self.specialties.each do |specialty|
      categories_names << specialty.category.name
    end
    categories_names_string = categories_names.sort.uniq.join(", ")
    return categories_names_string
  end

end

