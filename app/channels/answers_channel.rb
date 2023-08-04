class AnswersChannel < ApplicationCable::Channel
  def subscribed
    # question = Question.find(params[:question_id])
    # stream_for question
    stream_from("answers-question-#{params[:question_id]}")
  end
end
