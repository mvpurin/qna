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

  it 'does not send email to the author if he does not want' do
    author.update(author_notifications: false)
    expect(NewAnswerNotifyMailer).to_not receive(:notify_author).with(author, question, answer).and_call_original
    subject.notify_author(answer)
  end

  it 'sends email to subscribed users' do
    user.subscriptions.create(question_id: question.id)
    expect(NewAnswerNotifyMailer).to receive(:notify_subscribers).with(["#{user.email}"], question,
                                                                       answer).and_call_original
    subject.notify_subscribers(answer)
  end
end
