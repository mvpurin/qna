require 'rails_helper'

feature 'User get email notification', '
As an authenticated user I would like to get email notifications
when new answers are added to questions which I am subscribbed on.
I would like to get email notifications if I am an author of the question
' do
  given!(:question_author) { create(:user) }
  given!(:answer_author) { create(:user) }
  given!(:subscriber) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:subscription) { create(:subscription, user: subscriber, question: question) }

  background do
    sign_in(answer_author)
    visit question_path(question)

    within 'div.new-answer' do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer body'
    end

    perform_enqueued_jobs do
      click_on 'Give answer'
    end
  end

  describe 'Author', js: true do
    scenario 'wants to get notifications' do
      open_email(question_author.email)

      expect(current_email).to eq nil
    end

    # scenario 'does not want to get notifications' do

    # end
  end

  describe 'Subscriber', js: true do
    scenario 'is subscribed to the question' do
      open_email(subscriber.email)
      
      expect(current_email).to eq nil
    end

    scenario 'is not subscribed to the question'
  end
end