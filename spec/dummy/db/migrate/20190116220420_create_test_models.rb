# frozen_string_literal: true

class CreateTestModels < ActiveRecord::Migration[5.1]
  def change
    create_table :test_models do |t|
      t.text :text
      t.integer :uid
      t.text :state

      t.timestamps
    end
  end
end
