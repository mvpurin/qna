require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe "GET #search" do
    it 'returns list of items if items exist' do
      expect(ThinkingSphinx).to receive(:search).with('String').and_call_original
      get :search, params: { 'query' => 'String', 'object_field' => '' }
    end
  end
end
