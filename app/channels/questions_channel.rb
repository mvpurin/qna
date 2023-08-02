class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "question_#{params[:question_id]}"
    question = Question.find(params[:question_id])
    stream_for question
  end
end
