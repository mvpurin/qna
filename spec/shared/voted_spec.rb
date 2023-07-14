require 'rails_helper'

RSpec.shared_examples "a voted object" do
  let(:controller) { described_class }
  let(:votable) { create(controller.to_s.underscore.split('_')[0].singularize.to_sym) }
  let(:user) { create(:user) }

  before { login(user) }

  describe "GET #vote_for" do
    before { get :vote_for, params: { id: votable.id, format: :json } }

    it 'gets json response' do
      expect(response.header)
    end

    
  end

end


