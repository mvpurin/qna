require 'rails_helper'

RSpec.describe EmailConfirmationsController, type: :controller do
  describe 'POST #create' do
    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(user).to receive(:set_email_confirmation_token)
      end

      it 'send an email to user' do
        expect { post :create, params: { user: user } }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    it 'redirects to new_user_session_path' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'GET #confirm' do
    context 'user exists' do
      let!(:user) { create(:user) }
    end
  end
end
