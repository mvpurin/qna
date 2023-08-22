class Comment < ApplicationRecord
  after_create :publish_comment

  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  def publish_comment
    return if errors.any?

    ActionCable.server.broadcast(
      'comments',
      {
        comment: self
      }
    )
  end
end
