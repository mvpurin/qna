class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_instance, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    @comment.save
  end

  private

  def set_instance
    model_klass = [Question, Answer].find { |c| params["#{c.name.underscore}_id"] }
    @commentable = model_klass.find(params["#{model_klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
