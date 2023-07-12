class AddRatingToAnswersAndQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :likes, :integer, default: 0
    add_column :questions, :dislikes, :integer, default: 0
    add_column :answers, :likes, :integer, default: 0
    add_column :answers, :dislikes, :integer, default: 0
  end
end
