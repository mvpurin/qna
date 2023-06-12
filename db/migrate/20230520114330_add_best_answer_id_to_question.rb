class AddBestAnswerIdToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :best_answer, foreign_key: { to_table: :answers, on_delete: :nullify }, index: true
  end
end
