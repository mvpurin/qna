require 'rails_helper'

feature 'Sign in with Vkontakte', '
User is able to sign in or sign up with his Vkontakte account ' do
  given(:user) { create(:user) }

  context 'new user' do
    scenario 'provider provides email' do
      OmniAuth.config.add_mock(:vkontakte, uid: '12345', info: { email: 'new_user@email.com' })
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      open_email('new_user@email.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'provider does not provide email' do
      OmniAuth.config.add_mock(:vkontakte, uid: '12345', info: { email: nil })
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      fill_in 'Email', with: 'new_user@email.com'
      click_on 'Send email'
      open_email('new_user@email.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  context 'existing user' do
    scenario 'provider provides email' do
      OmniAuth.config.add_mock(:vkontakte, uid: '12345', info: { email: user.email })
      user.update(confirmed_at: DateTime.now)
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario 'provider does not provide email' do
      user.update(confirmed_at: DateTime.now)
      OmniAuth.config.add_mock(:vkontakte, uid: '12345', info: { email: nil })
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      fill_in 'Email', with: user.email
      click_on 'Send email'
      expect(page).to have_content 'Please try to sign in with your email and password'
    end
  end
end
