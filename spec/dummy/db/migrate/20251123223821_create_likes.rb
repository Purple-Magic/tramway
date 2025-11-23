# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :likes do |t|
      t.integer :post_id

      t.timestamps
    end
  end
end
