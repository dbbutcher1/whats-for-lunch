require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do

  include Devise::TestHelpers

  before do
    @user = User.create!(email: 'test@test.com', password: 'password', password_confirmation: 'password')
    @address = Address.create!(user_id: @user.id, zip_code: '30082')
    @restaurant = Restaurant.create!(name: 'Rspec Restaurant', google_place_id: 'asdfasdfsf')

    sign_in(@user)
  end

  describe 'GET index' do
    it 'renders the index page' do
      subject = get :index
      
      expect(subject).to render_template(:index)
    end

    it 'rediects to the edit page if a rating for the day exists' do
      rating = Rating.create!(user_id: @user.id, restaurant_id: @restaurant.id, rating: 4.5)

      subject = get :index

      expect(subject).to redirect_to(action: :edit, id: @restaurant.id)
    end
  end

  describe 'GET edit' do
    subject { get :edit, { id: @restaurant.id } }

    it 'renders the edit page' do
      expect(subject).to render_template(:edit)
    end
  end

  describe 'PATCH update' do

    it 'adds a rating to a restaurant and user if valid' do
      patch :update, { id: @restaurant.id, rating: { rating: '4.5' } }

      expect(@restaurant.ratings.first).to_not be_nil
      expect(@restaurant.ratings.first.rating).to eq 4.5
    end

    it 'updates a rating if one exists' do
      rating = Rating.create!(restaurant_id: @restaurant.id, user_id: @user.id, rating: 4.5)
      expect(rating.rating).to eq 4.5

      patch :update, { id: @restaurant.id, rating: { rating: '3' } }

      expect(@restaurant.ratings.first).to_not be_nil
      expect(@restaurant.ratings.first.rating).to eq 3
      expect(flash[:warning]).to eq 'Thanks for telling us how it was!'
    end

    it 'displays an error when the user rating is invalid' do
      patch :update, { id: @restaurant.id, rating: { rating: '60' } }

      expect(flash[:danger]).to_not be_nil
      expect(flash[:danger]).to eq 'Rating must be less than or equal to 5'
    end
  end
end
