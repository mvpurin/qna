require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user_2) { create(:user) }
  before { user_2.update(confirmed_at: DateTime.now) }
  before { login(user_2) }

  describe 'GET #vote_for' do
    before { get :vote_for, params: { vote: attributes_for(:vote), id: votable, user: user_2, format: :json } }

    it 'gets json response' do
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).to_json
      expect(response.status).to eq 200
    end

    it 'gets forbidden status if user has already voted' do
      get :vote_for, params: { vote: attributes_for(:vote), id: votable, user: user_2, format: :json }

      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).to_json
      expect(response.status).to eq 403
    end
  end

  describe 'GET #vote_against' do
    before { get :vote_against, params: { vote: attributes_for(:vote), id: votable, user: user_2, format: :json } }

    it 'gets json response' do
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).to_json
      expect(response.status).to eq 200
    end

    it 'gets forbidden status if user has already voted' do
      get :vote_against, params: { vote: attributes_for(:vote), id: votable, user: user_2, format: :json }

      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).to_json
      expect(response.status).to eq 403
    end
  end
end
