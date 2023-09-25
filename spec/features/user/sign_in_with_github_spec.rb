require 'rails_helper'

feature 'Sign in with Github', '
User is able to sign in or sign up with his Github account ' do
  given(:user) { create(:user) }  

  scenario 'new user' do
    OmniAuth.config.add_mock(:github, uid: '12345', info: { email: 'new_user@email.com' })
    visit new_user_session_path
    click_on 'Sign in with GitHub'
    open_email('new_user@email.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'existing user' do
    OmniAuth.config.add_mock(:github, uid: '12345', info: { email: user.email })
    user.update(confirmed_at: DateTime.now)
    visit new_user_session_path
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end
end
