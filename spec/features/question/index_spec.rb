require 'rails_helper'

feature 'User can see a list of questions', '
  As an authenticated user or not,
  I would like to see a list of questions
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User see a list of questions' do
    visit questions_path

    expect(page).to have_content question.title.to_s
    expect(page).to have_content question.body.to_s
  end
end
