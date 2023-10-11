module Services
  class NewAnswerNotify
    def notify_author(answer)
      question = answer.question
      author = User.find(question.user_id)

      NewAnswerNotifyMailer.notify_author(author, question, answer).deliver_later
    end

    def notify_subscribers(answer)
      question = answer.question
      subscribers = User.where(id: Subscription.where(question_id: question.id).pluck(:user_id)).pluck(:email)

      NewAnswerNotifyMailer.notify_subscribers(subscribers, question, answer).deliver_later      
    end
  end
end