# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :load_task, only: %i[show update destroy]

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

  def show
    render
  end

  def update
    if @task.update(task_params)
      render status: :ok, json: { notice: "Task successfully updated" }
    else
      render status: :unprocessable_entity, json: { error: task.errors.full_messages.to_sentance }
    end
  end

  def destroy
    if @task.destroy
      render status: :ok, json: { notice: "Task has been deleted" }
    else
      render status: :unprocessable_entity, json: { error: @task.errors.full_messages.to_sentance }
    end
  end

  private

    def task_params
      params.require(:task).permit(:title, :user_id)
    end

    def load_task
      @task = Task.find_by(slug: params[:slug])
      unless @task
        render status: :not_found, json: { error: t("not_found") }
      end
    end
end
