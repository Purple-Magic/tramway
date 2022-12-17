# frozen_string_literal: true

class AddDeletedAtToAllModels < ActiveRecord::Migration[5.1]
  def change
    add_column :another2_association_models, :deleted_at, :datetime
    add_column :another_association_models, :deleted_at, :datetime
    add_column :association2_models, :deleted_at, :datetime
    add_column :association_models, :deleted_at, :datetime
    add_column :test_models, :deleted_at, :datetime
  end
end
