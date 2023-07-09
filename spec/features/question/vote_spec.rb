require 'rails_helper'

feature 'User can vote for question', '
As an authenticated user I would like
to be able to vote for a question I like
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'votes for a question' do
      within '.questions' do
        click_on 'like'
        expect(page).to have_content 
    end
  end
end




end
