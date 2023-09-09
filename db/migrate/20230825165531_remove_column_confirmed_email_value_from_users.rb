class RemoveColumnConfirmedEmailValueFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :confirmed_email_value
  end
end
