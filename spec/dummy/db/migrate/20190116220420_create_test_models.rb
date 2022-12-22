class CreateTestModels < ActiveRecord::Migration[5.1]
  def change
    create_table :test_models do |t|
      t.text :text
      t.integer :uid
      t.text :state
      t.text :enumerized
      t.text :title
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
