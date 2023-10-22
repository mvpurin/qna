require 'sphinx_helper'

feature 'User can search for question, answer, comment and other user', "
  In order to find needed question, answer, comment or user
  As a User
  I'd like to be able to search for the answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: 'first question title', body: 'first querstion body', user: user) }
  given!(:answer) { create(:answer, title: 'first answer title', body: 'first answer body', question: question, user: user) }
  given!(:comment) { create(:comment, commentable: question, body: 'first comment', user: user) }

  background { visit root_path }

  scenario 'User searches for the question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select "Question", from: 'object_field'
      fill_in 'Search for:', with: 'first'
      click_on 'Search'

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'Questions'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end

  scenario 'User searches for the answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select "Answer", from: 'object_field'
      fill_in 'Search for:', with: 'first'
      click_on 'Search'

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'Answers'
      expect(page).to have_content answer.title
      expect(page).to have_content answer.body
    end
  end

  scenario 'User searches for the comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select "Comment", from: 'object_field'
      fill_in 'Search for:', with: 'first'
      click_on 'Search'

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'Comments'
      expect(page).to have_content comment.body
    end
  end

  scenario 'User searches everywhere', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search for:', with: 'first'
      click_on 'Search'

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'Answers'
      expect(page).to have_content 'Comments'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content answer.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
    end
  end
end