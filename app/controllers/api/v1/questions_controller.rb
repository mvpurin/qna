class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def destroy
    if can? :destroy, @question
      @question.destroy
      head :no_content
    else
      head :forbidden
    end
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
    if can? :update, @question
      @question.update(question_params)

      if @question.errors.any?
        response.status = 422
        render json: @question.errors.full_messages
      else
        render json: @question
      end
    else
      head :forbidden
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