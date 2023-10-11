class Answer < ApplicationRecord
  include Votable
  include Commentable
  after_create :publish_answer, :notify_author_and_subscribers

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def publish_answer
    return if errors.any?

    ActionCable.server.broadcast(
      'answers',
      {
        answer: self,
        rating: rating
      }
    )
  end

  def notify_author_and_subscribers
    NewAnswerNotifyJob.perform_later(self)
  end
end
