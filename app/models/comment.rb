class Comment < ApplicationRecord
  after_create :publish_comment

  belongs_to :user, optional: true
  belongs_to :commentable, polymorphic: true, optional: true

  validates :body, presence: true

  def publish_comment
    return if self.errors.any?

    question_id = self.commentable_type == "Question" ? self.commentable.id : self.commentable.question.id

    ActionCable.server.broadcast(
      "comments-question-#{question_id}",
      {
        comment: self
      }
    )
  end
end
