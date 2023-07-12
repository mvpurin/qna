require 'rails_helper'

feature 'User can vote for an answer', '
As an authenticated user I would like
to be able to vote for an answer I like
' do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:answer_2) { create(:answer, user: user_2, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for an answer' do
      within "div#answer-#{answer_2.id}" do
        click_on 'Like'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'votes against an answer' do
      within "div#answer-#{answer_2.id}" do
        click_on 'Dislike'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'votes for an answer twice' do
      within "div#answer-#{answer_2.id}" do
        click_on 'Like'
        click_on 'Like'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'votes for his answer' do
      within "div#answer-#{answer.id}" do
        click_on 'Like'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario 'Authenticated user tries to vote', js: true do
    visit questions_path
    expect(page).to_not have_content "Like"
    expect(page).to_not have_content "Dislike"
  end
end