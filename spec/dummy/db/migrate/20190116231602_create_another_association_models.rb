# frozen_string_literal: true

class CreateAnotherAssociationModels < ActiveRecord::Migration[5.1]
  def change
    create_table :another_association_models do |t|
      t.integer :uid
      t.integer :test_model_id
      t.text :state
      t.text :text

      t.timestamps
    end
  end
end
