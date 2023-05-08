require 'rails_helper'

feature 'User can delete an answer', '
  As an authenticated user
  I would like to delete answer
' do
  given!(:user_1) { create(:user) }
  given!(:user_2) { create(:user) }

  given!(:question_1) { create(:question, user: user_1) }
  given!(:question_2) { create(:question, user: user_2) }

  given!(:answer_1) { create(:answer, question: question_1, user: user_2) }
  given!(:answer_2) { create(:answer, question: question_2, user: user_1) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(user_1)

    visit question_path(question_2)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer was successfully deleted.'
  end
end
