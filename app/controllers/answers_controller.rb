class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show destroy update]

  def create
    @answer = @question.answers.new(answer_params)

    respond_to do |format|
      if @answer.save
        format.html { render @answer }
      else
        format.html { render partial: 'shared/errors', locals: { resource: @answer }, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    @answer.destroy if @answer.user_id == current_user.id
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
    params.require(:answer).permit(:title, :body, :user_id, files: [], links_attributes: %i[id url name url _destroy])
  end 
end
