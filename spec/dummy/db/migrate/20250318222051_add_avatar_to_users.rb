class AddAvatarToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :avatar, :string
  end
end
