# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all
    render status: :ok, json: { tasks: @tasks }
  end

  def create
    task = Task.create(task_params)
    if task.save
      render status: :ok, json: { notice: t("success") }
    else
      errors = task.error.full_messages.to_sentance
      render status: :unprocessable_entity, json: { error: errors }
    end
  end

  private

    def task_params
      params.require(:task).permit(:title)
    end
end
