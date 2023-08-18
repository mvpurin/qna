class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    last_question = Question.last
    stream_from("questions")
  end
end
