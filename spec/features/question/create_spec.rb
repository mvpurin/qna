require 'rails_helper'

feature 'User can create question', '
  In order to get answer from a community
  As an authenticated user
  I would like to ba able to ask a question
' do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Text question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Text question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
