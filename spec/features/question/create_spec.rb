require 'rails_helper'

feature 'User can create question', '
  In order to get answer from a community
  As an authenticated user
  I would like to ba able to ask a question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Text question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Text question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Text question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'
      click_on 'See question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question and add a badge' do
      fill_in 'Title', with: 'Text question'
      fill_in 'Body', with: 'text text text'

      within '.badge' do
        attach_file "#{Rails.root}/1.jpeg"
      end

      click_on 'Ask'
      click_on 'See question'

      expect(page).to have_content 'Has a badge for best answer!'
    end
  end

  context 'multiple sessions', js: true do

    scenario 'for adding question' do
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'

        fill_in 'Title', with: 'Text question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Your question was successfully created.'
        expect(page).to have_content 'Text question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Text question'
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'for adding comment' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end


      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within 'div.new-question-comment' do
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
    scenario 'tries to ask a question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'tries to add comment' do
      visit question_path(question)

      within 'div.new-question-comment' do
        expect(page).to_not have_content 'Add comment'
      end
    end
  end
end
