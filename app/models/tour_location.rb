class TourLocation < ApplicationRecord
  belongs_to :tour

  scope :country, -> (country) { where country: country }
  scope :state_or_province, -> (state_or_province) { where state_or_province: state_or_province }
end
