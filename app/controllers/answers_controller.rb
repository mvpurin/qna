class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show destroy update]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      redirect_to question_path(@answer.question_id), notice: 'Answer was successfully deleted.'
    else
      redirect_to question_path(@answer.question_id), notice: 'You can not delete answers of other users.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params[:answer][:user_id] = current_user.id
    params.require(:answer).permit(:title, :body, :user_id)
  end
end
