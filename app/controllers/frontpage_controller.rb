class FrontpageController < ApplicationController
  before_filter :authenticate_user!
  def index
    @todo = Todo.new

    @active_todos = current_user.active_todos.collect {|todo| {:id => todo.id, :description => todo.parsed_description } }
    @completed_todos = current_user.completed_todos.collect {|todo| {:id => todo.id, :description => todo.parsed_description } }

    @contexts = []
    current_user.todo_contexts.each do |context|
      @contexts << {:id => context.id, :name => context.name}
    end

    @projects = []
    current_user.projects.each do |project|
      @projects << {:id => project.id, :name => project.name}
    end

  end
end
