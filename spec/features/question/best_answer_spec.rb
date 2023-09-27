require 'rails_helper'

feature 'User can mark an answer as the best one', '
  As an authenticated user
   I would like to mark an answer to a question as the best one
' do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_1) { create(:answer, title: 'answer_title_1', question: question, user: user) }
  given!(:answer_2) { create(:answer, title: 'answer_title_2', question: question, user: user_2) }
  given!(:badge) { create(:badge, question: question, user: user_2) }

  background { user.update(confirmed_at: DateTime.now) }
  
  scenario 'Authenticated user tries to mark an answer as the best one', js: true do
    sign_in(user)
    visit question_path(question)

    within "div#answer-#{answer_2.id}" do
      click_on 'Best answer!'

      refresh
    end

    within '.answers' do
      first_div = first(:css, 'div')

      expect(first_div).to have_content answer_2.title
    end
  end

  scenario 'Unauthenticated user tries to mark an answer as the best one', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer!'
  end
end
