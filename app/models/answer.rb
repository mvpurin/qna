class Answer < ApplicationRecord
  include Votable
  include Commentable
  after_create :publish_answer

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  def publish_answer
    return if errors.any?

    ActionCable.server.broadcast("answers-question-#{question.id}",
                                 {
                                   answer: self,
                                   rating: rating
                                 })
  end
end
