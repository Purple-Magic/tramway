class CreateRents < ActiveRecord::Migration[5.1]
  def change
    create_table :rents do |t|
      t.integer :book_id
      t.integer :reader_id
      t.datetime :begin_date
      t.datetime :end_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
