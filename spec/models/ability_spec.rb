require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:other_answer) { create(:answer, user: other, question: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, user: user, question: question)}
    it { should_not be_able_to :update, create(:answer, user: other, question: question) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user, question: question) }
    it { should_not be_able_to :destroy, create(:answer, user: other, question: question) }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    
    it { should be_able_to :destroy, create(:link, linkable: answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }

    it { should be_able_to :vote_for, other_question }
    it { should_not be_able_to :vote_for, question }

    it { should be_able_to :vote_for, other_answer }
    it { should_not be_able_to :vote_for, answer }

    it { should be_able_to :vote_against, other_question }
    it { should_not be_able_to :vote_against, question }

    it { should be_able_to :vote_against, other_answer }
    it { should_not be_able_to :vote_against, answer }

    it 'should be able to delete files from his question' do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      file = question.files.all.first
      expect(ability).to be_able_to :destroy, file
    end

    it 'should not be able to delete files from questions of other users' do
      other_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      file = other_question.files.all.first
      expect(ability).to_not be_able_to :destroy, file
    end

    it 'should be able to delete files from his answer' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      file = answer.files.all.first
      expect(ability).to be_able_to :destroy, file
    end

    it 'should not be able to delete files from answers of other users' do
      other_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      file = other_answer.files.all.first
      expect(ability).to_not be_able_to :destroy, file
    end
  end
end