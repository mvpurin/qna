require 'rails_helper'

RSpec.shared_examples 'commentable' do
  describe described_class, type: :model do
    it { should have_many(:comments).dependent(:destroy) }
    it { should accept_nested_attributes_for :comments }
  end
end
