require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }  
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, user: user, question: question) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3 
        end

        it 'returns all public fields' do
          %w[id title body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }  
    end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let(:access_token) { create(:access_token) }

      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb', content_type: "application/x-ruby")
        question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb', content_type: "application/x-ruby")

        question.links.create(name: 'first', url: 'http://localhost:3000/questions')
        question.links.create(name: 'second', url: 'http://localhost:3000')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns returns all public fields' do
        %w[id title body created_at updated_at user_id best_answer_id likes dislikes].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns list of comments of question' do
        expect(json['question']['comments'].size).to eq 3
      end

      it 'returns list of urls of files of question' do
        file_1 = question.files.all.first
        file_2 = question.files.all.last

        expect(json['question']['files']).to include Rails.application.routes.url_helpers.rails_blob_url(file_1, host: 'localhost:3000')
        expect(json['question']['files']).to include Rails.application.routes.url_helpers.rails_blob_url(file_2, host: 'localhost:3000')
      end

      it 'returns list of links of question' do
        expect(json['question']['links'].first['url']).to eq 'http://localhost:3000/questions'
        expect(json['question']['links'].last['url']).to eq 'http://localhost:3000'
      end
    end
  end

  describe 'GET /api/v1/questions/id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }
    let(:answer) { answers.first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }  
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id title body user_id question_id likes dislikes created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end
end