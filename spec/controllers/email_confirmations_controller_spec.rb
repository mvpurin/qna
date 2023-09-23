require 'rails_helper'

RSpec.describe EmailConfirmationsController, type: :controller do
  describe 'POST #create' do
  #   context 'user exists' do
  #     let(:user) { create(:user) }
  #     let(:mailer) { double('EmailConfirmationMailer') }

  #     before do 
  #       post :create, params: { email: user.email }
  #     end

  #     it 'send an email to user' do       
  #       expect(EmailConfirmationMailer).to receive(:confirm_email).with(user).and_return(mailer)
  #       expect(mailer).to receive(:deliver_later)
  #     end
  #   end

    it 'redirects to new_user_session_path' do
      post :create, params: { email: 'some_email@email.com' }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'GET #confirm' do
    context 'user exists' do
      let(:user) { create(:user) }
      let(:session) { { auth: { provider: 'provider', uid: '123' } } }
      
      before { user.update(email_confirmation_token: '123') }

      it 'finds the user' do
        expect(User).to receive(:find_by).with(email: user.email, email_confirmation_token: user.email_confirmation_token)
        get :confirm, params: { user: { email: user.email, email_confirmation_token: user.email_confirmation_token } }
      end

      it 'finds the authorization' do
        expect(Authorization).to receive(:find_authorization).with(session[:auth][:provider], session[:auth][:uid])
        get :confirm, params: { user: { email: user.email, email_confirmation_token: user.email_confirmation_token } }

      end

      context 'and has an authorization' do
        it 'login user' do
          get :confirm, params: { user: { email: user.email, email_confirmation_token: user.email_confirmation_token } }
          expect(subject.current_user).to eq user
        end
      end

      context 'and does not have an authoriation' do
        it 'creates authorization for user' do
          
        end
      end

      it 'login user' do
        
      end
    end

    context 'user does not exist' do
      before do
        get :confirm, params: { user: { email: 'some_email@email.com', email_confirmation_token: '123' } }
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
