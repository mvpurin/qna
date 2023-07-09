class AddVotesQuestionsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :voted_questions, :jsonb, default: {}
  end
end
