class UsersController < ApplicationController
  before_action :authenticate_user!
  
  authorize_resource

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:author_notifications)
  end
end
