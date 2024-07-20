# frozen_string_literal: true

class AddAasmStateToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :aasm_state, :string
  end
end
