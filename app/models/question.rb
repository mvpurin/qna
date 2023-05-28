class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true

  def other_answers
    answers.where.not(id: best_answer.id)
  end
end
