class CreateReaders < ActiveRecord::Migration[5.1]
  def change
    create_table :readers do |t|
      t.text :username
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
