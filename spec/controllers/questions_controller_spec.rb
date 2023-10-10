require 'rails_helper'
# require 'shared/voted_spec'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it_behaves_like 'voted' do
    let(:user) { create(:user) }
    let(:votable) { create(:question, user: user) }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:answer_1) { create(:answer, question: question, user: user) }
    let!(:answer_2) { create(:answer, question: question, user: user) }
    let!(:answer_3) { create(:answer, question: question, user: user) }

    before { question.update(best_answer: answer_1) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link to @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'assigns best_answer and other_answers to @best_answer and @other_answers' do
      expect(assigns(:best_answer)).to eq answer_1
      expect(assigns(:other_answers)).to eq [answer_2, answer_3]
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question.links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Badge to @question' do
      expect(assigns(:question).badge).to be_a_new(Badge)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user_2) { create(:user) }
    let!(:answer) { create(:answer, user: user_2, question: question) }
    let!(:badge) { create(:badge, question: question) }

    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    context 'with valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        expect(question.reload.title).to eq 'new title'
        expect(question.reload.body).to eq 'new body'
      end

      it 'adds best_answer_id to question and user_id to badge' do
        patch :update, params: { id: question, question: { best_answer_id: answer } }, format: :js

        expect(question.reload.best_answer_id).to eq answer.id
        expect(question.reload.badge.user_id).to eq user_2.id
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :title)
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }

    let!(:question) { create(:question, user: user) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'GET #subscribe' do
    before { user.update(confirmed_at: DateTime.now) }
    before { login(user) }
    
    let!(:question) { create(:question, user: user) }

    context 'user does not have a subscription yet' do
      it 'saves a new subscription to database' do
        expect { get :subscribe, params: { id: question, format: :js } }.to change(Subscription, :count).by(1)
      end
    end

    context 'user has already subscribed' do
      before { get :subscribe, params: { id: question }, format: :json }
      
      it 'deletes subscription from database' do
        expect { get :subscribe, params: { id: question }, format: :json }.to change(Subscription, :count).by(-1)
      end
    end
  end
end
