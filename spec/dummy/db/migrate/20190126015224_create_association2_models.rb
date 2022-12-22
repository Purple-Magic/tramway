class CreateAssociation2Models < ActiveRecord::Migration[5.1]
  def change
    create_table :association2_models do |t|
      t.text :state
      t.integer :test_model_id
      t.integer :uid
      t.text :text
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
