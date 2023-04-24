require 'rails_helper'

feature 'User can delete an answer', %q{
  As an authenticated user
  I would like to delete answer
} do
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

    expect(page).to have_content 'Question was successfully deleted.'
  end

  scenario 'Authenticated user tries to delete an answer of another user' do
    sign_in(user_1)

    visit question_path(question_1)

    click_on 'Delete answer'

    expect(page).to have_content 'You can not delete answers of other users.'
  end
end