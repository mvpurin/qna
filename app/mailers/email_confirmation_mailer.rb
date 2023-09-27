class EmailConfirmationMailer < ApplicationMailer
  def confirm_email
    @user = params[:user]
    mail to: @user.email, subject: 'Email confirmation | QNA app'
  end
end
