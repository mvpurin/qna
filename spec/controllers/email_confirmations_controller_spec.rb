require 'rails_helper'

RSpec.describe EmailConfirmationsController, type: :controller do
  describe 'POST #create' do
    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_by).and_call_original
        allow(User).to receive(:find_by).with(user.email)
        allow(user).to receive(:set_email_confirmation_token)
        post :create, params: { user: user }
      end

      it 'send an email to user' do
        expect(ActionMailer::Base.deliveries.size).to eq 1
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
