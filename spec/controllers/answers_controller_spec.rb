require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        end.to change(Answer, :count).by(1)
      end

      it 'renders show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: question }
        end.not_to change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to render_template :new
      end
    end
  end
end
