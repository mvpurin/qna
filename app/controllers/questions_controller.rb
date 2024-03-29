class QuestionsController < ApplicationController
  include Voted

  skip_authorization_check only: %i[index show subscribe]
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy vote subscribe]
  before_action :load_subscription, only: :subscribe

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = @question.id

    @answer = @question.answers.new
    @answer.links.new

    return unless @question.best_answer

    @best_answer = @question.best_answer
    @other_answers = @question.other_answers
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_badge
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path,
                  notice: 'Your question was successfully created. You will receive notifications about new answers to your question. See Settings to refuse.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    @questions = Question.all

    return false if params[:question][:best_answer_id].nil?

    user = @question.answers.find(params[:question][:best_answer_id].to_i).user
    @question.badge.update(user_id: user.id) if @question.badge.present?
  end

  def destroy
    if can? :destroy, @question
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted.'
    else
      redirect_to question_path(@question), notice: 'You can not delete questions of other users.'
    end
  end

  def subscribe
    respond_to do |format|
      if @subscription.nil?
        current_user.subscriptions.create(question_id: params[:id])
        format.json { render json: 'Subscribed!', adapter: nil }
      else
        @subscription.destroy
        format.json { render json: 'Unsubscribed!', adapter: nil }
      end
    end
  end

  private

  def load_subscription
    @subscription = Subscription.find_by(user_id: current_user.id, question_id: params[:id])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params[:question][:badge_attributes][:title] = 'Best answer!' unless params[:question][:badge_attributes].nil?
    params.require(:question).permit(:title, :body, :best_answer_id, :rating, files: [],
                                                                              links_attributes: %i[id name url _destroy],
                                                                              badge_attributes: %i[id title user_id file _destroy])
  end
end
