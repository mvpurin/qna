require 'rails_helper'

RSpec.describe Badge, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:badge) { create(:badge, user: user, question: question) }
  before { badge.file.attach(io: File.open("#{Rails.root}/1.jpeg"), filename: '1.jpeg') }

  it { should belong_to(:question) }
  it { should belong_to(:user).optional }

  it 'have one attached file' do
    expect(Badge.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it 'should allow image/jpeg file type' do
    expect(badge).to be_valid
  end
end
