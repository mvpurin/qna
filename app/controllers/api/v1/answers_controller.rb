class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer
  before_action :load_answer, only: [:show, :destroy, :update]
  
  def index
    @answers = Answer.where(question_id: params[:question_id])
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def destroy
    if can? :destroy, @answer
      @answer.destroy
      head :no_content
    else
      head :forbidden
    end
  end

  def create
    @question = Question.find(params[:question_id])

    @answer = @question.answers.new(answer_params)
    
    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      response.status = 422
      render json: @answer.errors.full_messages
    end
  end

  def update
    if can? :update, @answer
      @answer.update(answer_params)

      if @answer.errors.any?
        response.status = 422
        render json: @answer.errors.full_messages
      else
        render json: @answer
      end
    else
      head :forbidden
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params[:answer][:user_id] = current_resource_owner.id
    params.require(:answer).permit(:title, :body, :user_id, links_attributes: %i[id url name url _destroy])
  end
end