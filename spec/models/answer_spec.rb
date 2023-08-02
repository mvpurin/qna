require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:votable) { create(:answer, user: user, question: question, likes: 5, dislikes: 2) }
    let!(:vote) { votable.votes.create(user: user) }
  end
end
