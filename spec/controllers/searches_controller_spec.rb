require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe "GET #search" do
    it 'returns list of items if items exist' do
      expect(ThinkingSphinx).to receive(:search).with('Question').and_return([question])
      get :search, params: { 'query' => 'Question', 'object_field' => '' }
    end
  end
end
