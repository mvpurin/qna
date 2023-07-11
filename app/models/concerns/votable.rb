module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voted_value?(user)
    find_vote(user)
    @vote ? @vote.value : nil
  end

  def rating
    self.likes - self.dislikes
  end

  def find_vote(user)
    @vote = Vote.find_by(user_id: user.id, votable_id: self.id)
  end

end