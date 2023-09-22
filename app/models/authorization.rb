class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  scope :find_authorization, ->(provider, uid) { where(provider: provider, uid: uid).first }
end
