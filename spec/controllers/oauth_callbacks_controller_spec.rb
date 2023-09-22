require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    context 'provider provides email' do
      let(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123, 'info' => { 'email' => 'email@email.com' } } }

      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :vkontakte
      end

      context 'user exists' do
        let(:user) { create(:user) }
        let(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123, 'info' => { 'email' => user.email } } }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth).and_return(user)
          get :vkontakte
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        let(:oauth_data) do
          { 'provider' => 'vkontakte', 'uid' => 123, 'info' => { 'email' => 'some_email@email.com' } }
        end

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth).and_return(nil)
          get :vkontakte
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end
      end
    end

    context 'provider does not provide email' do
      let(:user) { create(:user) }
      let(:oauth_data) { { 'provider' => 'vkontakte', 'uid' => 123, 'info' => { 'email' => nil } } }

      context 'user has an authorization' do
        let(:authorization) { create(:authorization, provider: 'vkontakte', uid: 123, user: user) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(Authorization).to receive(:find_authorization).and_return(authorization)
          get :vkontakte
        end

        it 'returns the authorization' do
          expect(Authorization.find_authorization('vkontakte', 123)).to eq authorization
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end
      end

      context 'user has not an authorization' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(Authorization).to receive(:find_authorization).and_return(nil)
          get :vkontakte
        end

        it 'add request.env to session' do
          expect(session[:auth]).to eq oauth_data
        end

        it 'redirects to email_confirmation_controller' do
          expect(response).to redirect_to new_email_confirmation_path
        end
      end
    end
  end
end
