require 'rails_helper'

feature 'User can vote for question', '
As an authenticated user I would like
to be able to vote for a question I like
' do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user_2)
      visit questions_path
    end

    scenario 'votes for a question' do
      within "div#question-#{question.id}" do
        click_on 'Like'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'votes against a question' do
      within "div#question-#{question.id}" do
        click_on 'Dislike'
        expect(page).to have_content 'Rating: -1'
      end
    end
  end
end
