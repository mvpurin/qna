require 'rails_helper'

feature 'Sign in with Vkontakte', '
User is able to sign in or sign up with his Vkontakte account ' do
  background do
    OmniAuth.config.test_mode = true
  end

  given!(:user) { create(:user) }

  describe 'request has email' do
    scenario 'existed user tries to sign in' do
      OmniAuth.config.add_mock(:vkontakte, uid: '12345', info: { email: user.email })
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario 'new user tries to sign up' do
      OmniAuth.config.add_mock(:vkontakte, uid: '12345', info: { email: 'new_user@email.com' })
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
  end

  describe 'request does not have email' do
    scenario 'existed user tries to sign in'
    scenario 'new user tries to sign up'
  end
end
