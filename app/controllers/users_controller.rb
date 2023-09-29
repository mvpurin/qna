class UsersController < ApplicationController
  before_action :authenticate_user!
  
  authorize_resource

  def show
    @user = User.find(params[:id])
  end
end
