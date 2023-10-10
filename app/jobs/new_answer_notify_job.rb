class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotify.new.notify_author(answer)
  end
end
