module RestaurantsHelper

  def random_restaurant(user, yesterdays_rating, address=Address.first)
    service = ApplicationHelper.places_service

    restaurants = service.get_restaurants(address)
    restaurant_choice = sort_and_weight_restaurants(user, restaurants).first
    

    # Make sure we have a rating from yesterday
    unless yesterdays_rating.nil?
      # Make a new selection if the restaurants match
      while restaurant_choice.id == yesterdays_rating.restaurant.id do
        restaurant_choice = sort_and_weight_restaurants(user, restaurants)
      end
    end

    restaurant_choice
  end

  def ratings_by_date_and_user(user, date_to_query = DateTime.now.utc)
    Rating.where(updated_at: date_to_query.beginning_of_day..date_to_query.end_of_day, user_id: user.id)
  end

  private

  def sort_and_weight_restaurants(user, restaurants)
    weight_restaurants = []

    restaurants.each do |restaurant|
      rating = Rating.find_by(user_id: user.id, restaurant_id: restaurant.id)
      weight_restaurants << {
        restaurant: restaurant,
        weight: rand(0..100) + (rating.nil? ? 0 : rating.calculate_weighted_value)
      }
    end

    restaurants.sort_by { |r| r[:weight] } 
  end
end
