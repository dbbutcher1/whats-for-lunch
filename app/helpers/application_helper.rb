module ApplicationHelper
  def self.places_service
    GooglePlacesService.new
  end
end
