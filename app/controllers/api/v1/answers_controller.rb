class Api::V1::AnswersController < Api::V1::BaseController
  skip_authorization_check only: [:index, :show, :destroy]
  
  def index
    @answers = Answer.where(question_id: params[:question_id])
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer, serializer: AnswerSerializer
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    head :no_content
  end
end