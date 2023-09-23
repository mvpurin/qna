class EmailConfirmationsController < ApplicationController
  before_action :set_user, only: %i[confirm]

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      user.set_email_confirmation_token

      EmailConfirmationMailer.with(user: user).confirm_email.deliver_later
    end

    redirect_to new_user_session_path, notice: 'Success! Please check your E-mail'
  end

  def confirm
    user = set_user

    authorization = Authorization.find_authorization(session[:auth]['provider'], session[:auth]['uid'])

    user.authorizations.create(provider: session[:auth]['provider'], uid: session[:auth]['uid']) if authorization.nil?

    user.clear_email_confirmation_token

    sign_in_and_redirect user
  end

  private

  def set_user
    user = User.find_by(email: params[:user][:email],
                        email_confirmation_token: params[:user][:email_confirmation_token])

    return user if user&.email_confirmation_token_period_valid?

    redirect_to(new_user_session_path,
                flash: { warning: 'Email confirmation failed' })
  end
end
