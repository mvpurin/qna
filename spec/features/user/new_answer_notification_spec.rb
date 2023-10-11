require 'rails_helper'

feature 'User get email notification', '
As an authenticated user I would like to get email notifications
when new answers are added to questions which I am subscribbed on.
I would like to get email notifications if I am an author of the question
' do
  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  # given(:subscriber) { create(:user) }
  given(:question) { create(:question, user: question_author) }

  describe 'Author', js: true do
    background do
      question_author.update(confirmed_at: DateTime.now)
      answer_author.update(confirmed_at: DateTime.now)
    end

    scenario 'wants to get notifications' do
      sign_in(answer_author)
      visit question_path(question)
      within 'div.new-answer' do
        fill_in 'Title', with: 'Answer title'
        fill_in 'Body', with: 'Answer body'
      end
      click_on 'Give answer'
      # sleep(120)

      open_email("#{question_author.email}")
      save_and_open_page
      expect(current_email).to have_content 'Your question has a new answer!'
      expect(current_email).to have_content 'Answer title'
      expect(current_email).to have_content 'Answer body'
    end
  end
end