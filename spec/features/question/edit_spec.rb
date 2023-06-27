require 'rails_helper'

feature 'User can edit his question', '
  As an authenticated user
  I would like to edit my question
' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }
  given!(:wiki_url) { 'https://wikipedia.org' }
  given(:gist_url) { 'https://gist.github.com/mvpurin/83c2d2c5906fc1dede66178da2763697' }

  scenario 'Unauthenticated user tries to edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'tries to edit his question' do
      within "div#question-#{question.id}" do
        click_on 'Edit question'

        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'add link'

        fill_in 'Link name', with: 'Wikipedia'
        fill_in 'Url', with: wiki_url

        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'gist'
          fill_in 'Url', with: gist_url
        end

        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end

      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'Wikipedia', href: wiki_url
      expect(page).to have_content 'QNA gist'
    end

    scenario 'tries to edit his question with errors' do
      within "div#question-#{question.id}" do
        click_on 'Edit question'
        fill_in 'Title', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      within "div#question-#{question2.id}" do
        expect(page).to_not have_content 'Edit question'
      end
    end

    scenario 'tries to delete attached files' do
      within "div#question-#{question.id}" do
        click_on 'Edit question'
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
      end

      visit question_path(question)
      click_on 'Delete file'

      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'tries to delete links from question' do
      within "div#question-#{question.id}" do
        click_on 'Edit question'
        click_on 'add link'

        fill_in 'Link name', with: 'Wikipedia'
        fill_in 'Url', with: wiki_url

        click_on 'Save'
      end

      visit question_path(question)

      click_on 'Delete link'

      expect(page).to_not have_link 'Wikipedia'
    end
  end
end
