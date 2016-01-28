class Restaurant < ActiveRecord::Base

  has_many :ratings

  validates :name, presence: true

  accepts_nested_attributes_for :ratings
end
