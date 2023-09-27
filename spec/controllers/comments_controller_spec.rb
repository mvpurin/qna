require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question comment to database' do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question, user_id: user }
        end.to change(Comment, :count).by(1)
      end

      it 'saves a new answer comment to database' do
        expect do
          post :create, params: { comment: attributes_for(:comment), answer_id: answer, user_id: user }
        end.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect do
          post :create,
               params: { comment: attributes_for(:comment, :invalid), question_id: question, user_id: user }
        end.not_to change(Comment, :count)
      end

      it 'does not save the comment' do
        expect do
          post :create,
               params: { comment: attributes_for(:comment, :invalid), answer_id: answer, user_id: user }
        end.not_to change(Comment, :count)
      end
    end
  end
end
