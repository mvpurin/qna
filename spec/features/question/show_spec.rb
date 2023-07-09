require 'rails_helper'

feature 'User can see a question and its answers', '
  As an authenticated user or not
  I would like to see a question and its answers
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User see question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title.to_s
    expect(page).to have_content question.body.to_s

    expect(page).to have_content answer.title.to_s
    expect(page).to have_content answer.body.to_s
  end
end
