###
# Controller for front page of application

class FrontpageController < ApplicationController
  before_filter :authenticate_user!

  # GET /
  # @return [void]
  def index
    set_preferences
    bootstrap_page
  end

  # Toggle the status of the :show_help user preference
  # @return [void]
  def toggle_help
    if current_user.preferences[:show_help].nil?
      current_user.preferences[:show_help] = false
    else
      current_user.preferences[:show_help] = current_user.preferences[:show_help] ? false : true
    end

    current_user.save

    respond_to do |format|
      format.html { render :json => current_user.preferences[:show_help] }
    end
  end

  private

  def bootstrap_page
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

  def set_preferences
    @show_help = current_user.preferences[:show_help].nil? ? true : current_user.preferences[:show_help]
  end
end
