class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.integer :value, default: 0
      t.belongs_to :votable, polymorphic: true
      t.belongs_to :user

      t.timestamps
    end
  end
end
