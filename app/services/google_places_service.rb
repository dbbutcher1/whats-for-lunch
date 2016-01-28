require 'google_places'

class GooglePlacesService

  def get_restaurants(address)
    g_client = GooglePlaces::Client.new(Rails.application.secrets.google_places_api_key)
    lat, long = address.coordinates

    # Caching responses due to limitations with the google api. 1000 requests per day
    results = Rails.cache.fetch("#{address.id}/places_query", expires_in: 12.hours) do
      g_client.spots(lat, long, types: ['restaurant', 'food'])
    end


    find_or_create_restaurants(results)
  end

  private

  def find_or_create_restaurants(google_places_results)
    restaurant_information = google_places_results.collect { |p| { name: p.name, google_place_id: p.place_id } }

    restaurants = []
    restaurant_information.each do |restaurant|
      restaurants << Restaurant.find_or_create_by(restaurant)
    end

    restaurants
  end
end