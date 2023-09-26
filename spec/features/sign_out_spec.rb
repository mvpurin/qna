require 'rails_helper'

feature 'User can sign out', '
  As an authenticated user
  I would like to be able to sign out
' do
  given(:user) { create(:user) }

  background { user.update(confirmed_at: DateTime.now) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
