class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.string :title
      t.text :body
      t.belongs_to :question, index: true, foreign_key: true

      t.timestamps
    end
  end
end
