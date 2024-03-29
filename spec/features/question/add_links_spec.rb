require 'rails_helper'

feature 'User can add links to question', "
  In order to provide addition al info to my question
  As an question's author
  I would like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/mvpurin/83c2d2c5906fc1dede66178da2763697' }
  given(:wiki_url) { 'https://wikipedia.org' }

  background { user.update(confirmed_at: DateTime.now) }

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Wikipedia'
      fill_in 'Url', with: wiki_url
    end

    click_on 'Ask'

    click_on 'See question'

    expect(page).to have_content 'QNA gist'
    expect(page).to have_link 'Wikipedia', href: wiki_url
  end
end
