class Specialty < ApplicationRecord
  belongs_to :technician
  belongs_to :category
end
