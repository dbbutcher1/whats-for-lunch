include RestaurantsHelper

class RestaurantsController < ApplicationController

  def index
    # Check to see if the user has eaten today by looking for an updated rating.
    # If yes, take them to the edit page, if no, show them something new.
    # Using UTC for database
    todays_user_rating = ratings_by_date_and_user(current_user).first
    yesterdays_rating = ratings_by_date_and_user(current_user, DateTime.now.utc - 1.day).first

    if current_user.address.nil? || current_user.address.zip_code.blank?
      flash[:warning] = "You're missing an address! #{link_to 'Click here', edit_user_path} to add one. Here's a random restaurant in the mean time..."
      @restaurant = random_restaurant(current_user, yesterdays_rating)
    elsif !todays_user_rating.nil?
      flash[:warning] = "Looks like you've eaten today! Please rate the restaurant if you haven't already."
      redirect_to edit_restaurant_path(todays_user_rating.restaurant.id)
    else
      @restaurant = random_restaurant(current_user, yesterdays_rating, current_user.address)
    end
  end

  def edit
    flash[:warning] = "Don't forget to click the 'I have eaten there now' button after you eat!!"
    @restaurant = Restaurant.find(params[:id])

    @user_rating = @restaurant.ratings.find_or_initialize_by(user_id: current_user.id)
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @user_rating = @restaurant.ratings.find_or_create_by(user_id: current_user.id)
    
    @user_rating.assign_attributes(rating_params)

    if @user_rating.save
      flash[:warning] = "Thanks for telling us how it was!"
      render :edit
    else
      flash[:danger] = @user_rating.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:rating)
  end
end
