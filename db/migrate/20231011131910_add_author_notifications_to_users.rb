class AddAuthorNotificationsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :author_notifications, :boolean, default: true
  end
end
