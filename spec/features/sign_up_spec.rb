require 'rails_helper'

feature 'User can sign up', '
  As unregistered user
  I would like to sign up
' do
  scenario 'Unregistered user can sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: '123456789'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'
    open_email('test@email.com')
    current_email.click_link 'Confirm my account'
    
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
