# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    render html: "This is index action of Tasks controller"
  end
end
