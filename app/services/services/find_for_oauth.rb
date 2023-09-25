module Services
  class FindForOauth
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email]

      user = User.where(email: email).first

      if user
        user.create_authorization(auth)
      elsif user.nil? && email.present?
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      elsif user.nil? && email.nil?
        # password = Devise.friendly_token[0, 20]
        # email = '11111@email.com'
        # user = User.create!(email: email, password: password, password_confirmation: password)
        # user.create_authorization(auth)
        return nil
      end
      user
    end
  end
end
