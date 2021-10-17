# frozen_string_literal: true

class AddAllTaskUserReferences < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :tasks, :users, column: :user_id
    add_foreign_key :tasks, :users, column: :task_owner_id, on_delete: :cascade
  end
end
