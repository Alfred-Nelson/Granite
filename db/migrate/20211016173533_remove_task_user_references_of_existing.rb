# frozen_string_literal: true

class RemoveTaskUserReferencesOfExisting < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :tasks, :users
  end
end
