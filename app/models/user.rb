class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def set_email_confirmation_token
    Services::ConfirmEmail.new(self).call
  end

  def email_confirmation_token_period_valid?
    email_confirmation_token_sent_at.present? && Time.current - email_confirmation_token_sent_at <= 60.minutes
  end

  def clear_email_confirmation_token
    self.email_confirmation_token = nil
    self.email_confirmation_token_sent_at = nil
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
