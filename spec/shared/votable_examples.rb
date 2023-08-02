require 'rails_helper'

RSpec.shared_examples 'votable' do
  describe described_class, type: :model do
    it { should have_many(:votes).dependent(:destroy) }
  end

  it 'should calculate a rating' do
    expect(votable.rating).to eq(3)
  end

  it 'should find a vote' do
    expect(Vote.find_by(user_id: user.id, votable_id: votable.id)).to eq(vote)
  end

  it 'should check if user has already voted' do
    expect(votable.find_vote(user)).to eq(vote)
  end
end
