# Preview all emails at http://localhost:3000/rails/mailers/new_answer
class NewAnswerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer/send_message
  def send_message
    NewAnswerMailer.send_message
  end

end
