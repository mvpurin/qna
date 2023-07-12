module Voted
  extend ActiveSupport::Concern

  def vote_for
    respond_to do |format|
      @instance = instance
      if @instance.voted_value?(current_user) == 1 || @instance.user_id == current_user.id
        format.json do
          render json: @instance,
                 status: :forbidden
        end
      end

      if @instance.voted_value?(current_user).nil?
        @instance.votes.create(user_id: current_user.id, value: 1)
        @instance.likes += 1
      end

      if @instance.voted_value?(current_user) == -1
        @instance.likes += 1
        @instance.dislikes -= 1
        @instance.find_vote(current_user).update(value: 1)
      end

      @instance.save

      format.json { render json: @instance }
    end
  end

  def vote_against
    respond_to do |format|
      @instance = instance
      if @instance.voted_value?(current_user) == -1 || @instance.user_id == current_user.id
        format.json do
          render json: @instance,
                 status: :forbidden
        end
      end

      if @instance.voted_value?(current_user).nil?
        @instance.votes.create(user_id: current_user.id, value: -1)
        @instance.dislikes += 1
      end

      if @instance.voted_value?(current_user) == 1
        @instance.likes -= 1
        @instance.dislikes += 1
        @instance.find_vote(current_user).update(value: -1)
      end

      @instance.save

      format.json { render json: @instance }
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def instance_name
    controller_name.chop.to_sym
  end

  def instance
    model_klass.find(params[:id])
  end
end
