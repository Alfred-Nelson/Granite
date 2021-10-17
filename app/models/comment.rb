# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :content, presence: true, length: { maximum: Constants::MAX_COMMENT_LENGTH }
  validates :task_id, presence: true
  validates :user_id, presence: true
end
