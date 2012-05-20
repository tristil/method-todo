class FrontpageController < ApplicationController
  before_filter :authenticate_user!
  def index
    @todo = Todo.new

    @active_todos = current_user.active_todos.reverse
    @completed_todos = current_user.completed_todos.reverse

    @contexts = current_user.todo_contexts
    @projects = current_user.projects
  end
end
