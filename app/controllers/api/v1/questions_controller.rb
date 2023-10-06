class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check only: [:index, :show, :destroy]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question, serializer: QuestionSerializer
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    head :no_content
  end
end