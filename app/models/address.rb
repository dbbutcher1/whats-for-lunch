class Address < ActiveRecord::Base

  belongs_to :user

  validates :city, :state, :zip_code, presence: true, if: :address?

  def coordinates
    if self.address?
      Geocoder.search("#{address} #{city}, #{state} #{zip_code}").first.coordinates
    else
      Geocoder.search(self.zip_code).first.coordinates
    end
  end
end
