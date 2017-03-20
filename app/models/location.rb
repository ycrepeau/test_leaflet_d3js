class Location < ApplicationRecord
  validates :name, presence: true
  validates :latitude, numericality:{greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0}
  validates :longitude, numericality:{greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0}
end
