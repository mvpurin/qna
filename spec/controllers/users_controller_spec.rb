require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    user.update(confirmed_at: DateTime.now)
    login(user)
  end

  describe 'GET #show' do
    before { get :show, params: { id: user } }

    it 'assigns requested user to @user' do
      expect(assigns(:user)).to eq user
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: user } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { patch :update, params: { id: user, user: { author_notifications: 0 } } }

    it 'changes author_notifications for user to false' do
      expect(user.reload.author_notifications).to eq false
    end
  end
end
