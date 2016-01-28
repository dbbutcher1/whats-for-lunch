require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RestaurantsHelper. For example:
#
# describe RestaurantsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe RestaurantsHelper, type: :helper do

  before do
    @user = User.create!(email: 'test@test.com', password: 'password', password_confirmation: 'password')
    @address = Address.create!(user_id: @user.id, zip_code: '30082')
    @restaurants = [Restaurant.create!(name: 'Rspec Restaurant', google_place_id: 'asdfasfdasdf'), Restaurant.create!(name: 'Rspec restaurant 2', google_place_id: 'asdfasdfadf')]
    @rating = Rating.create!(user_id: @user.id, restaurant_id: @restaurants[0].id, rating: 3.5)
    @yesterdays_rating = Rating.create!(user_id: @user.id, restaurant_id: @restaurants[0].id, rating: 3.5, updated_at: DateTime.now.utc - 1.day)
  end
  
  describe "random_restaurant" do
    it 'returns a restaurant when provided yesterdays rating' do
      restaurant = random_restaurant(@user, @rating)

      expect(restaurant).to_not be_nil
      expect(restaurant).to be_a Restaurant
    end

    it 'returns a restaurant when provided yesterdays rating and an address' do
      restaurant = random_restaurant(@user, @rating, @address)

      expect(restaurant).to_not be_nil
      expect(restaurant).to be_a Restaurant
    end

  end

  describe "ratings_by_date_and_user" do

    it 'returns todays rating' do
      ratings = ratings_by_date_and_user(@user)

      expect(ratings.count).to eq 1
      expect(ratings.first).to eq @rating
    end

    it 'returns yesterdays ratings when provided a yesterdays date' do
      ratings = ratings_by_date_and_user(@user, DateTime.now.utc - 1.day)

      expect(ratings.count).to eq 1
      expect(ratings.first).to eq @yesterdays_rating
    end
  end
end
