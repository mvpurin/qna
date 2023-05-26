require 'rails_helper'

feature 'User can create answer', '
  As an authenticated user
  I would like to ba able to give an answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to give an answer', js: true do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer body'
      click_on 'Give answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer title'
      expect(page).to have_content 'Answer body'
    end

    scenario 'tries to give an answer with errors', js: true do
      click_on 'Give answer'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer', js: true do
    visit question_path(question)

    click_on 'Give answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
