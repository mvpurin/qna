module Services
  class ConfirmEmail
    def initialize(user)
      @user = user
    end

    def call
      # @user.update email_confirmation_token: SecureRandom.urlsafe_base64(20),
      #              email_confirmation_token_sent_at: Time.current
    end
  end
end
