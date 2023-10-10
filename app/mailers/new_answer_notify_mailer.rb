class NewAnswerNotifyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_mailer.send_message.subject
  #
  def notify_author(user, question, answer)
    @greeting = "Hi"
    @question = question
    @answer = answer

    mail to: user.email, subject: 'New answer! | QNA app'
  end
end
