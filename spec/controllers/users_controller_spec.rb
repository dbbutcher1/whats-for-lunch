require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  include Devise::TestHelpers

  before do
    @user = User.create!(email: 'test@test.com', password: 'password', password_confirmation: 'password')
    @address = Address.create!(user_id: @user.id, zip_code: '30082')

    sign_in(@user)
  end

  describe 'GET new' do
    subject { get :new }

    it 'renders the new page' do
      expect(subject).to render_template(:new)
    end
  end

  describe 'POST create' do

    it 'creates a new user when the record is valid' do
      params = { user: { email: 'test_create@test.com', password: 'password', password_confirmation: 'password', address_attributes: { zip_code: '30324' } } }

      subject = post :create, params

      user = User.last

      expect(subject).to redirect_to(edit_user_path)
      expect(user).to_not be_nil
      expect(user.email).to eq params[:user][:email]
      expect(user.address).to_not be_nil
      expect(user.address.zip_code).to eq params[:user][:address_attributes][:zip_code]
    end

    it 'displays an error when the user record is invalid' do
      params = { user: { email: 'test_create@test.com', address_attributes: { zip_code: '30324' } } }

      subject = post :create, params

      expect(subject).to render_template(:new)
      expect(flash[:danger]).to eq "Password can't be blank"
    end
  end

  describe 'GET show' do
    subject { get :show }

    it 'renders the show page' do
      expect(subject).to render_template(:show)
    end
  end

  describe 'GET edit' do
    subject { get :edit }

    it 'renders the edit page' do
      expect(subject).to render_template(:edit)
    end
  end

  describe 'PATCH update' do

    it 'updates the user and address record when valid' do
      params = { user: { email: 'test+rspec@test.com', address_attributes: { zip_code: '30324' } } }

      patch :update, params

      @user = @user.reload

      expect(@user.address.zip_code).to eq params[:user][:address_attributes][:zip_code]
      expect(@user.email).to eq params[:user][:email]
    end

    it 'displays an error when the record is invalid' do
      # Address only validates when the address field is filled out but missing city / state
      params = { user: { address_attributes: { address: '123 Main Street', zip_code: '30324' } } }

      subject = patch :update, params

      expect(subject).to render_template(:edit)
      expect(flash[:danger]).to eq "Address city can't be blank and Address state can't be blank"
    end
  end
end
