require 'rails_helper'

feature 'User can see a list of questions', '
  As an authenticated user or not,
  I would like to see a list of questions
' do
  given!(:question) { create(:question) }

  scenario 'User see a list of questions' do
    visit questions_path
    save_and_open_page

    expect(page).to have_content "#{question.title}"
    expect(page).to have_content "#{question.body}"
  end
end
