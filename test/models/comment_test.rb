# frozen_string_literal: true

require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = build(:comment)
    @user = create(:user)
    @task = create(:task)
  end

  def test_comment_should_be_invalid_without_content
    @comment.content = ""
    assert @comment.invalid?
  end

  def test_comment_content_should_not_exceed_maximum_length
    @comment.content = "a" * 200
    assert @comment.invalid?
  end

  def test_valid_comment_should_be_saved
    @comment.task = @task
    @comment.user = @user
    assert_difference "Comment.count" do
      @comment.save
    end
  end

  def test_comment_should_not_be_valid_without_user
    @comment.user = nil
    assert @comment.invalid?
  end

  def test_comment_should_not_be_valid_without_task
    @comment.task = nil
    assert @comment.invalid?
  end
end
