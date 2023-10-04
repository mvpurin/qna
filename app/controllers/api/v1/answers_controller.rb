class Api::V1::AnswersController < Api::V1::BaseController
  skip_authorization_check only: [:index]
  
  def index
    @answers = Answer.where(question_id: params[:question_id])
    render json: @answers, each_serializer: AnswersSerializer
  end
end