require 'rails_helper'
# require 'shared/votable_spec'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge) }
  it { should belong_to(:user) }
  it { should belong_to(:best_answer).optional }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) {create(:user)} 
    let(:votable) { create(:question, user: user, likes: 5, dislikes: 2) }
    let!(:vote) { votable.votes.create(user: user) }
  end
end
