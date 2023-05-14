require 'rails_helper'

feature 'User can edit his question', %q{
  As an authenticated user
  I wuold like to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path
    end
  
    scenario 'tries to edit his question' do
      click_on 'Edit question'

      within '.questions' do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end





    scenario 'tries to edit his question with answers'
    scenario "tries to edit other user's question"
  end
end