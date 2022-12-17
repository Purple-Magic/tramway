# frozen_string_literal: true

class CreateAnother2AssociationModels < ActiveRecord::Migration[5.1]
  def change
    create_table :another2_association_models do |t|
      t.text :state
      t.integer :test_model_id
      t.integer :uid
      t.text :text

      t.timestamps
    end
  end
end
