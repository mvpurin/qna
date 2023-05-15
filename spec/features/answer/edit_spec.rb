require 'rails_helper'

feature 'User can edit his answer', '
  In order to correct mistakes
  As an author of answer
  I would like to be able to edit my answer
' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) } 
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)   
    end

    scenario 'edits his answer' do
      within "div#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'edited answer title'
        fill_in 'Body', with: 'edited answer body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer title'
        expect(page).to have_content 'edited answer body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within "div#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save' 
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's answer" do
      within "div#answer-#{answer2.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
