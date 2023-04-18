require 'rails_helper'

feature 'User can create answer', %q{
  As an authenticated user
  I would like to ba able to give an answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user tries to give an answer' do
    sign_in(user)

    visit question_path(question)

    fill_in 'Title', with: 'Answer title'
    fill_in 'Body', with: 'Answer body' 
    click_on 'Give answer'

    expect(page).to have_content 'Your answer was successfully created.'
    expect(page).to have_content 'Answer title'
    expect(page).to have_content 'Answer body'
  end

  scenario 'Authenticated user tries to give an answer with errors'
  scenario 'Unauthenticated user tries to give an answer'
end