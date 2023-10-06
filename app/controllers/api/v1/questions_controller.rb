class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check only: [:index, :show, :destroy, :create, :update]

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
    @question = Question.find(params[:id])
    @question.update(question_params)

    if !@question.errors.any?
      render json: @question
    else
      response.status = 422
      render json: @question.errors.full_messages
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url _destroy])  
  end
end