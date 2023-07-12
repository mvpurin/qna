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

    scenario 'tries to give an answer' do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Give answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer title'
      expect(page).to have_content 'Answer body'

      refresh # until use JS template engine

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      save_and_open_page
    end

    scenario 'tries to give an answer with errors' do
      click_on 'Give answer'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Give answer'
  end
end
