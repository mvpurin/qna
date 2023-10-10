module Services
  class NewAnswerNotify
    def notify_author(answer)
      question = answer.question
      author = User.find(question.user_id)

      NewAnswerNotifyMailer.notify_author(author, question, answer).deliver_later
    end
  end
end