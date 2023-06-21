require 'rails_helper'

feature 'User can edit his answer', '
  In order to correct mistakes
  As an author of answer
  I would like to be able to edit my answer
' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }
  given(:gist_url) { 'https://gist.github.com/mvpurin/83c2d2c5906fc1dede66178da2763697' }
  given(:wiki_url) { 'https://wikipedia.org' }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within "div#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'edited answer title'
        fill_in 'Body', with: 'edited answer body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'add link'
        fill_in 'Link name', with: 'Wikipedia'
        fill_in 'Url', with: wiki_url

        # click_on 'add link'

        # within all('.nested-fields').last do
        #   fill_in 'Link name', with: 'gist'
        #   fill_in 'Url', with: gist_url
        # end

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer title'
        expect(page).to have_content 'edited answer body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'Wikipedia', href: wiki_url
        # expect(page).to have_content 'QNA gist'
        expect(page).to_not have_selector 'textarea'
        save_and_open_page
      end
    end

    scenario 'edits his answer with errors' do
      within "div#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's answer" do
      within "div#answer-#{answer2.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'tries to delete attached files' do
      within "div#answer-#{answer.id}" do
        click_on 'Edit'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'

        click_on 'Delete file'
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    scenario 'tries to delete links from answer' do
      within "div#answer-#{answer.id}" do
        click_on 'Edit'
        click_on 'add link'
        fill_in 'Link name', with: 'Wikipedia'
        fill_in 'Url', with: wiki_url
        click_on 'Save'

        click_on 'Delete link'
        expect(page).to_not have_link 'Wikipedia'
      end
    end
  end
end
