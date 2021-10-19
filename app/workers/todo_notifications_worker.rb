# frozen_string_literal: true

class TodoNotificationsWorker
  include Sidekiq::Worker

  def perform
    # Do something
    todo_notification_service = TodoNotificationService.new
    todo_notification_service.process
  end
end
