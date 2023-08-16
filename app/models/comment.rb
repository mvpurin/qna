class Comment < ApplicationRecord
  after_create :publish_comment

  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  def publish_comment
    return if errors.any?

    question_id = commentable_type == 'Question' ? commentable.id : commentable.question.id

    ActionCable.server.broadcast(
      "comments-question-#{question_id}",
      {
        comment: self
      }
    )
  end
end
