require 'rails_helper'

feature 'Sign in with Github', '
User is able to sign in or sign up with his Github account ' do
  background do
    OmniAuth.config.test_mode = true
  end

  given!(:user) { create(:user) }

  scenario 'existed user tries to sign up' do
    OmniAuth.config.add_mock(:github, uid: '12345', info: { email: user.email })
    visit new_user_session_path
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'new user tries to sign up' do
    OmniAuth.config.add_mock(:github, uid: '12345', info: { email: 'new_user@email.com' })
    visit new_user_session_path
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end
end
