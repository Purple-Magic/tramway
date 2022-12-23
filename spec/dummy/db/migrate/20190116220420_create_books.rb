class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.text :title
      t.text :description
      t.string :state
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
