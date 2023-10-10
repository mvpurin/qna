require 'rails_helper'

RSpec.describe Services::NewAnswerNotify do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'sends email to an author of the question' do
    expect(NewAnswerNotifyMailer).to receive(:notify_author).with(author, question, answer).and_call_original
    subject.notify_author(answer)
  end
end