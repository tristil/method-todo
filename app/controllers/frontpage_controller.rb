class FrontpageController < ApplicationController
  before_filter :authenticate_user!
  def index
    @todo = Todo.new

    @active_todos = current_user.active_todos.collect {|todo| todo.as_json }
    @completed_todos = current_user.completed_todos.collect {|todo| todo.as_json }

    @contexts = []
    current_user.todo_contexts.each do |context|
      @contexts << {:id => context.id, :name => context.name}
    end

    @projects = []
    current_user.projects.each do |project|
      @projects << {:id => project.id, :name => project.name}
    end

    @tags = []
    current_user.tags.each do |tag|
      @tags << {:id => tag.id, :name => tag.name}
    end

  end
end
