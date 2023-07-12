require 'rails_helper'

RSpec.shared_examples 'votable' do
  let(:user) { create(:user) }
  let(:model) { described_class }
  let(:instance) { create(model.to_s.underscore.to_sym, user: user, likes: 5, dislikes: 2) }
  let!(:vote) { instance.votes.create!(votable_type: model.to_s, votable: instance, user: user) }

  it { should have_many(:votes).dependent(:destroy) }

  it 'should find a vote' do
    expect(Vote.find_by(user_id: user.id, votable_id: instance.id)).to eq(vote)
  end

  it 'should calculate a rating' do
    expect(instance.rating).to eq(3)
  end

  it 'should check if user has already voted for instance' do
    expect(instance.find_vote(user)).to eq(vote)
  end
end
