# frozen_string_literal: true

class AddEnumerizedToTestModels < ActiveRecord::Migration[5.1]
  def change
    add_column :test_models, :enumerized, :text
  end
end
