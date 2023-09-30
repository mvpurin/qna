class ApplicationController < ActionController::Base
  before_action :gon_user
  
  def gon_user
    gon.user_id = current_user.id if current_user
  end

  check_authorization :unless => :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
end
