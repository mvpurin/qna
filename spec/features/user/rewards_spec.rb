require 'rails_helper'

feature 'User can see list of his rewards', '
As an authenticated user
I would like to see my rewards
include question title,
image of rewars and its title
' do
  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user_1) }
  given(:answer) { create(:answer, user: user_2, question: question) }
  given(:badge) { create(:badge, user: user_2, question: question) }
  before { user_2.update(confirmed_at: DateTime.now) }
  before { badge.file.attach(io: File.open("#{Rails.root}/1.jpeg"), filename: '1.jpeg') }
  before { question.update(best_answer_id: answer) }

  scenario 'Authenticated user can see his reward list' do
    sign_in(user_2)
    visit user_path(user_2)

    expect(page).to have_content(badge.title.to_s)
    expect(page).to have_content(question.title.to_s)
    expect(page).to have_css('img')
  end

  scenario 'Unauthenticated user tries to see reward list' do
    visit user_path(user_2)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
