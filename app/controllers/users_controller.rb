class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [ :new, :create ]

  def show
    @user = current_user
  end

  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'Successfully created your profile!'
      sign_in(@user)
      redirect_to after_sign_in_path_for(@user)
    else
      flash[:danger] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = current_user

    if @user.address.nil?
      @user.address = Address.new
    end
  end

  def update
    @user ||= current_user

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    @user.assign_attributes(user_params)

    if @user.save
      flash[:success] = 'Updated successfully!'
      redirect_to user_path
    else
      flash[:danger] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, address_attributes: [:city, :state, :address, :zip_code])
  end
end
