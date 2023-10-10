require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do
  let(:service) { double('Services::NewAnswerNotify') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question:question, user: user) }

  before do
    allow(Services::NewAnswerNotify).to receive(:new).and_return(service)
  end
  
  it 'calls Service::NewAnswreNotify#notify_author' do
    expect(service).to receive(:notify_author).with(answer)
    NewAnswerNotifyJob.perform_now(answer)
  end
end
