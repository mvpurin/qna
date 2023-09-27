require 'rails_helper'

feature 'User can sign in', '
  In order to ask questions
  As an unauthenticated user
  I would like to be able to sigh in
' do
  given(:user) { create(:user) }

  background { visit new_user_session_path }
  background { user.update(confirmed_at: DateTime.now) }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
