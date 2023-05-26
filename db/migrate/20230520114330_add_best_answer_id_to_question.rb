class AddBestAnswerIdToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :best_answer, foreign_key: { to_table: :answers }, index: true
  end
end
