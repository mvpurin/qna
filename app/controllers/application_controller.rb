class ApplicationController < ActionController::Base
  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
