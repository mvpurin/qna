require 'rails_helper'

describe 'Answers API', type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'GET /api/v1/answers/id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }  
    end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let(:access_token) { create(:access_token) }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: "application/x-ruby")
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb', content_type: "application/x-ruby")

        answer.links.create(name: 'first', url: 'http://localhost:3000/questions')
        answer.links.create(name: 'second', url: 'http://localhost:3000')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns returns all public fields' do
        %w[id title body created_at updated_at user_id likes dislikes].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'returns list of comments of answer' do
        expect(json['answer']['comments'].size).to eq 3
      end

      it 'returns list of urls of files of answer' do
        file_1 = answer.files.all.first
        file_2 = answer.files.all.last

        expect(json['answer']['files']).to include Rails.application.routes.url_helpers.rails_blob_url(file_1, host: 'localhost:3000')
        expect(json['answer']['files']).to include Rails.application.routes.url_helpers.rails_blob_url(file_2, host: 'localhost:3000')
      end

      it 'returns list of links of answer' do
        expect(json['answer']['links'].first['url']).to eq 'http://localhost:3000/questions'
        expect(json['answer']['links'].last['url']).to eq 'http://localhost:3000'
      end
    end
  end

  describe 'DELETE /api/v1/answer/id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }  
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        delete api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns no_content status' do 
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes the answer' do
        expect(Answer.all.size).to eq 0
      end
    end
  end

  describe 'POST #create /api/v1/questions/id/answers' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }  
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }

      context 'with valid attributes' do
        before do
          post api_path, params: { access_token: access_token.token, answer: {title: "fdgee", body: "fgdg", links_attributes: [{ name: "link", url: "https://dfg.com" }]} }, headers: headers
        end

        it 'returns 200 status' do 
          expect(response).to be_successful
        end

        it 'saves a new answer to database' do
          expect(Answer.all.size).to eq 1
        end

        it 'attached a link to the answer' do
          expect(Link.all.size).to eq 1
        end
      end

      context 'with invalid attributes' do
        before do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
        end

        it 'returns 422 status' do 
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not save invalid answer to database' do
          expect(Answer.all.size).to eq 0
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }  
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { title: "new title", body: "new body", links_attributes: [{ name: "new link", url: "https://dfg.com" }] } }, headers: headers
        end

        it 'returns 200 status' do 
          expect(response).to be_successful
        end

        it 'changes the answer with new params' do
          expect(answer.reload.title).to eq "new title"
          expect(answer.reload.body).to eq "new body"
          expect(Link.all.size).to eq 1
        end
      end

      context 'with missing fields' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { title: "new title" } }, headers: headers
        end
        
        it 'returns 200 status' do 
          expect(response).to be_successful
        end

        it 'does not change missing fields' do
          expect(answer.reload.title).to eq "new title"
          expect(answer.reload.body).to eq "AnswerBody"
        end

        it 'does not create a new answer' do
          expect(Answer.all.size).to eq 1
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) }, headers: headers
        end

        it 'returns 422 status' do 
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change the answer' do
          expect(answer.reload.title).to eq "AnswerTitle"
          expect(answer.reload.body).to eq "AnswerBody"
        end
      end
    end
  end
end