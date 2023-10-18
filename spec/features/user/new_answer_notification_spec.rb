require 'rails_helper'

feature 'User get email notification', '
As an authenticated user I would like to get email notifications
when new answers are added to questions which I am subscribbed on.
I would like to get email notifications if I am an author of the question
' do
  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:subscriber) { create(:user) }
  given(:question) { create(:question, user: question_author) }

  describe 'Author', js: true do
    scenario 'wants to get notifications' do
      answer_author_create_answer

      open_email(question_author.email)

      expect(current_email.body).to include 'Your question has a new answer!'
      expect(current_email.body).to include question.title
      expect(current_email.body).to include Answer.first.title
      expect(current_email.body).to include Answer.first.body
    end

    scenario 'does not want to get notifications' do
      sign_in(question_author)
      visit edit_user_path(question_author)
      uncheck 'user_author_notifications'
      click_on 'Submit'
      click_on 'Sign out'

      answer_author_create_answer

      open_email(question_author.email)

      expect(current_email).to eq nil
    end
  end

  describe 'Subscriber', js: true do
    scenario 'is subscribed to the question' do
      sign_in(subscriber)
      visit question_path(question)
      click_on 'Subscribe to the question!'
      sleep(1)
      page.driver.browser.switch_to.alert.accept
      click_on 'Sign out'

      answer_author_create_answer

      open_email(subscriber.email)

      expect(current_email.body).to include 'The question, which you are subscribed on:'
      expect(current_email.body).to include question.title
      expect(current_email.body).to include Answer.first.title
      expect(current_email.body).to include Answer.first.title
    end

    scenario 'is not subscribed to the question' do
      answer_author_create_answer

      open_email(subscriber.email)

      expect(current_email).to eq nil
    end
  end
end

def answer_author_create_answer
  sign_in(answer_author)
  visit question_path(question)

  within 'div.new-answer' do
    fill_in 'Title', with: 'Answer title'
    fill_in 'Body', with: 'Answer body'
  end

  perform_enqueued_jobs do
    click_on 'Give answer'
    sleep(1)
  end
end