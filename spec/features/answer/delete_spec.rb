require 'rails_helper'

feature 'User can delete an answer', '
  As an authenticated user
  I would like to delete answer
' do
  given!(:user_1) { create(:user) }
  given!(:user_2) { create(:user) }

  given!(:question) { create(:question, user: user_1) }

  given!(:answer_1) { create(:answer, question: question, user: user_1) }
  given!(:answer_2) do
    create(:answer, title: 'answer_2_title', body: 'answer_2_body', question: question, user: user_2)
  end

  describe 'Authenticated user', js: true do
    background do
      user_1.update(confirmed_at: DateTime.now)
      sign_in(user_1)
      visit question_path(question)
    end

    scenario 'tries to delete his answer' do
      within "div#answer-#{answer_1.id}" do
        click_on 'Delete answer'
      end

      expect(page).to_not have_content answer_1.title
      expect(page).to_not have_content answer_1.body
    end

    scenario 'tries to delete an answer of another user' do
      within "div#answer-#{answer_2.id}" do
        expect(page).to_not have_link 'Delete answer'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
