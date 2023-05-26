require 'rails_helper'

feature 'User can delete a question', '
  As an authenticated user
  I would like to delete question
' do
  given!(:user_1) { create(:user) }
  given!(:user_2) { create(:user) }

  given!(:question_1) { create(:question, user: user_1) }
  given!(:question_2) { create(:question, user: user_2) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user_1)

    visit questions_path

    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted.'
  end
end
