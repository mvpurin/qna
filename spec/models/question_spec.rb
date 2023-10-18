require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }
  it { should have_one(:badge) }
  it { should belong_to(:user) }
  it { should belong_to(:best_answer).optional }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let(:votable) { create(:question, user: user, likes: 5, dislikes: 2) }
    let!(:vote) { votable.votes.create(user: user) }
  end

  it_behaves_like 'commentable'

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
