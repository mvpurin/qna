class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :destroy, :update]
  authorize_resource class: Question

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def destroy
    @question.destroy
    head :no_content
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    
    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      response.status = 422
      render json: @question.errors.full_messages
    end
  end

  def update
    @question.update(question_params)

    if @question.errors.any?
      response.status = 422
      render json: @question.errors.full_messages
    else
      render json: @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url _destroy])  
  end
end