require 'rails_helper'

feature 'User can subscribe on the question', '
  As an authenticated user
  I would like to be able to subscribe on the question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      user.update(confirmed_at: DateTime.now)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can subscribe on question' do
      click_on 'Subscribe to the question!'

      expect(page).to have_content 'Unsubscribe!'
      expect(page).to_not have_content 'Subscribe to the question!'
    end 

    scenario 'can cancel his subscription' do
      click_on 'Subscribe to the question!'
      click_on 'Unsubscribe!'

      expect(page).to have_content 'Subscribe to the question!'
      expect(page).to_not have_content 'Unsubscribe!'
    end 
  end

  describe 'Unauthenticated user' do
    scenario 'can not subscribe' do
      visit question_path(question)
      expect(page).to_not have_content 'Subscribe to the question!'
    end
  end
end