# frozen_string_literal: true

class Task < ApplicationRecord
  RESTRICTED_ATTRIBUTES = %i[title user_id]
  enum status: { unstarred: 0, starred: 1 }
  enum progress: { pending: 0, completed: 1 }
  belongs_to :user
  belongs_to :task_owner, foreign_key: "task_owner_id", class_name: "User"
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { maximum: Constants::MAX_TITLE_LENGTH }
  validates :slug, uniqueness: true
  validate :slug_not_changed
  validate :user_is_present
  before_create :set_slug

  private

    def set_slug
      title_slug = title.parameterize
      regex_pattern = "slug #{Constants::DB_REGEX_OPERATOR} ?"
      latest_task_slug = Task.where(
        regex_pattern,
        "#{title_slug}$|#{title_slug}-[0-9]+$"
      ).order(slug: :desc).first&.slug
      slug_count = 0
      if latest_task_slug.present?
        slug_count = latest_task_slug.split("-").last.to_i
        only_one_slug_exists = slug_count == 0
        slug_count = 1 if only_one_slug_exists
      end
      slug_candidate = slug_count.positive? ? "#{title_slug}-#{slug_count + 1}" : title_slug
      self.slug = slug_candidate
    end

    def slug_not_changed
      if slug_changed? && self.persisted?
        errors.add(:slug, t("task.slug.immutable"))
      end
    end

    def user_is_present
      if user_id == nil
        errors.add(:user_id, "must exist")
      end
    end

    def self.of_status(progress)
      if progress == :pending
        starred = pending.starred.order("updated_at DESC")
        unstarred = pending.unstarred.order("updated_at DESC")
      else
        starred = completed.starred.order("updated_at DESC")
        unstarred = completed.unstarred.order("updated_at DESC")
      end
      starred + unstarred
    end

    def test_error_raised_for_duplicate_slug
      another_test_task = Task.create!(title: "another test task", assigned_user: @user, task_owner: @user)

      assert_raises ActiveRecord::RecordInvalid do
        another_test_task.update!(slug: @task.slug)
      end

      error_msg = another_test_task.errors.full_messages.to_sentence
      assert_match t("task.slug.immutable"), error_msg
    end

    def test_updating_title_does_not_update_slug
      assert_no_changes -> { @task.reload.slug } do
        updated_task_title = "updated task title"
        @task.update!(title: updated_task_title)
        assert_equal updated_task_title, @task.title
      end
    end
end
