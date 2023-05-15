require 'rails_helper'

feature 'User can edit his question', %q{
  As an authenticated user
  I wuold like to edit my question
} do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }

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

      within "div#question-#{question.id}" do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
    end
  
    scenario 'tries to edit his question with errors' do
      click_on 'Edit question'

      within "div#question-#{question.id}" do
        fill_in 'Title', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit questions_path

      within "div#question-#{question2.id}" do  
        expect(page).to_not have_content 'Edit question'
      end    
    end
  end
end