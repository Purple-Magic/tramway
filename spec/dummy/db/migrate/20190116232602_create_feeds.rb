class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.integer :associated_id
      t.text :associated_type
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
