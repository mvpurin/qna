require 'rails_helper'

RSpec.describe EmailConfirmationsController, type: :controller do
  describe 'GET #new' do
    it 'should render new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'user exists' do
      before { expect(User).to receive(:find_by).and_return(user) }

      it 'does not login user' do
        post :create, params: { email: user.email }
        expect(subject.current_user).to_not be
      end

      it 'does not create new user' do
        expect { post :create, params: { email: user.email } }.to_not change(User, :count)
      end

      it 'redirects to new user session path' do
        post :create, params: { email: user.email }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user does not exist' do
      let(:session) { { auth: { provider: 'provider', uid: '123' } } }
      
      before { expect(User).to receive(:find_by).and_return(nil) }

      it 'creates new user' do
        expect { post :create, params: { email: 'new_user_email@email.com' }, session: { auth: { 'provider' => 'vkontakte', 'uid' => '123' } } }.to change(User, :count).by(1)
      end

      it 'creates new authorization for user' do
        expect { post :create, params: { email: 'new_user_email@email.com' }, session: { auth: { 'provider' => 'vkontakte', 'uid' => '123' } } }.to change(Authorization, :count).by(1)
      end
    end
  end
end