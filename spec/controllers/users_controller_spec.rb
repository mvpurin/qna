require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { get :show, params: {id: user} }

    it 'assigns requested user to @user' do
      expect(assigns(:user)).to eq user
    end
  end
end