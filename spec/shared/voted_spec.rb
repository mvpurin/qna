require 'rails_helper'

RSpec.shared_examples "a voted object" do
  let!(:user) { create(:user) }

  before { login(user) }

  describe "GET #vote_for" do
    before { get :vote_for, params: { votable: votable, user: user, format: :json } }

    it 'gets json response' do
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq (assigns(:votable)).to_json
    end

    it 'gets forbidden status if user has already voted' do
      get :vote_for, params: { id: votable.id, format: :json }

      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq (assigns(:votable)).to_json
      expect(response.status).to eq 403
    end
  end
end

RSpec.describe Question, type: :controller do
  it_behaves_like "a voted object" do
    let!(:votable) { create(:question, user: user) }
  end
end


