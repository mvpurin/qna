module Voted
  extend ActiveSupport::Concern

  def vote_for
    respond_to do |format|
      @votable = instance
      if @votable.voted_value?(current_user) == 1 || !(can? :vote_for, @votable)
        format.json do
          render json: @votable,
                 status: :forbidden,
                 adapter: nil
        end

      elsif @votable.voted_value?(current_user).nil?
        @votable.votes.create(user_id: current_user.id, value: 1)
        @votable.likes += 1

      elsif @votable.voted_value?(current_user) == -1
        @votable.likes += 1
        @votable.dislikes -= 1
        @votable.find_vote(current_user).update(value: 1)
      end

      @votable.save

      format.json { render json: @votable, adapter: nil }
    end
  end

  def vote_against
    respond_to do |format|
      @votable = instance
      if @votable.voted_value?(current_user) == -1 || !(can? :vote_against, @votable)
        format.json do
          render json: @votable,
                 status: :forbidden,
                 adapter: nil
        end

      elsif @votable.voted_value?(current_user).nil?
        @votable.votes.create(user_id: current_user.id, value: -1)
        @votable.dislikes += 1

      elsif @votable.voted_value?(current_user) == 1
        @votable.likes -= 1
        @votable.dislikes += 1
        @votable.find_vote(current_user).update(value: -1)
      end

      @votable.save

      format.json { render json: @votable, adapter: nil }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def instance
    model_klass.find(params[:id])
  end
end
