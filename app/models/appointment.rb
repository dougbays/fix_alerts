class Appointment < ApplicationRecord
  belongs_to :client
  belongs_to :technician
end
