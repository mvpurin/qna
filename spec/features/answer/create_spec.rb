require 'rails_helper'

feature 'User can create answer', '
  As an authenticated user
  I would like to ba able to give an answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      user.update(confirmed_at: DateTime.now)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to give an answer' do
      fill_in 'Title', with: 'Answer title'
      fill_in 'Body', with: 'Answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Give answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer title'
      expect(page).to have_content 'Answer body'

      refresh # until use JS template engine

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'tries to give an answer with errors' do
      click_on 'Give answer'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'multiple sessions', js: true do
    scenario 'for adding answer' do
      Capybara.using_session('user') do
        user.update(confirmed_at: DateTime.now)
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within 'div.new-answer' do
          fill_in 'Title', with: 'Answer title'
          fill_in 'Body', with: 'Answer body'
          click_on 'Give answer'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_content 'Answer title'
        expect(page).to have_content 'Answer body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer title'
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'for adding comment' do
      Capybara.using_session('user') do
        user.update(confirmed_at: DateTime.now)
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "div#answer-#{answer.id}" do
          click_on 'Add comment'
          fill_in 'Body', with: 'New comment body'
          click_on 'Add comment'
        end

        expect(page).to have_content 'New comment body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New comment body'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to give an answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Give answer'
    end

    scenario 'tries to add comment' do
      visit question_path(question)

      within 'div.answers' do
        expect(page).to_not have_content 'Add comment'
      end
    end
  end
end
