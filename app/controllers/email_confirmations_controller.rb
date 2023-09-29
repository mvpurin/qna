class EmailConfirmationsController < ApplicationController
  skip_authorization_check only: [:new, :create]
  
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user
      redirect_to new_user_session_path, notice: 'Please try to sign in with your email and password'
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: params[:email], password: password, password_confirmation: password)
      user.authorizations.create!(provider: session[:auth]['provider'], uid: session[:auth]['uid'])
    end
  end
end
