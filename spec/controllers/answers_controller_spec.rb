require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it_behaves_like 'voted' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:votable) { create(:answer, question: question, user: user) }
  end

  describe 'POST #create' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user, format: :json }
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user,
                         format: :json }
        end.not_to change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
    end

    it 'renders destroy template' do
      delete :destroy, params: { id: answer, format: :js }
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { title: 'new title', body: 'new body' } }, format: :js
        answer.reload

        expect(answer.title).to eq 'new title'
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :title)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
