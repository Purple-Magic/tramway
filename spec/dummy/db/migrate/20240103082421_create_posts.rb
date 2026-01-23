# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :text
      t.string :post_type

      t.timestamps
    end
  end
end
