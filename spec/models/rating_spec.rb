require 'rails_helper'

RSpec.describe Rating, type: :model do
  
  describe "increment_times_had" do
    before do
      user = User.create!(email: 'tester@test.com', password: 'password', password_confirmation: 'password')
      restaurant = Restaurant.create!(name: 'test', google_place_id: 'asdfasdf')

      @rating = Rating.create!(user_id: user.id, restaurant_id: restaurant.id, rating: 3.5)
    end

    it 'increments times_had by one when saved' do
      expect(@rating.times_had).to eq 1

      @rating.save
      expect(@rating.times_had).to eq 2
    end
  end
end
