require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide addition al info to my answer
  As an answer's author
  I would like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/mvpurin/83c2d2c5906fc1dede66178da2763697' }

  scenario 'User adds link when gives answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Title', with: 'Test answer'
    fill_in 'Body', with: 'Text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Give answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
