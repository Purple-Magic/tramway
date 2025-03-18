# frozen_string_literal: true

class AddInfoToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :country, :string
    add_column :users, :personal_info, :string
  end
end
