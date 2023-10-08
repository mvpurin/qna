class Question < ApplicationRecord
  include Votable
  include Commentable

  after_create :publish_question
  after_create :calculate_reputation
  
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :badge, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  def other_answers
    answers.where.not(id: best_answer.id)
  end

  def publish_question
    ActionCable.server.broadcast(
      'questions',
      {
        question: self,
        rating: rating
      }
    )
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
