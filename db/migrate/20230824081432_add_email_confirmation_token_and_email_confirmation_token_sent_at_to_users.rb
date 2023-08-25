class AddEmailConfirmationTokenAndEmailConfirmationTokenSentAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_confirmation_token, :string
    add_index :users, :email_confirmation_token
    add_column :users, :email_confirmation_token_sent_at, :datetime
  end
end
