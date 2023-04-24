require 'rails_helper'

feature 'User can sign up', %q{
  As unregistered user
  I would like to sign up
} do
  scenario 'Unregistered user can sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end