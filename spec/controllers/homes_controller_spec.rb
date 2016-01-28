require 'rails_helper'

RSpec.describe HomesController, type: :controller do

  describe 'GET show' do
    subject { get :show }

    it 'renders the show page' do
      expect(subject).to render_template(:show)
    end
  end
end
