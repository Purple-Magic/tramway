# frozen_string_literal: true

class CreateAssociationModels < ActiveRecord::Migration[5.1]
  def change
    create_table :association_models do |t|
      t.integer :test_model_id
      t.integer :uid
      t.text :text
      t.text :state

      t.timestamps
    end
  end
end
