class TodosController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:context_id]
      context = TodoContext.find_by_id params[:context_id]
      todos = context.todos
    elsif params[:project_id]
      project = Project.find_by_id params[:project_id]
      todos = project.todos
    else
      todos = current_user.active_todos
    end

    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => 'todos/todolist', :locals => {:todos => todos}
        end
      }
    end
  end

  def completed
    todos = current_user.completed_todos

    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => 'todos/todolist', :locals => {:todos => todos}
        end
      }
    end
  end

  def complete
    id = params[:id]
    json_response = {'completed' => false}
    todo = Todo.find_by_id id

    if todo and todo.user_id == current_user.id
      if params.include? :complete and ["0", "false"].include? params[:complete]
        json_response['completed'] = false
        todo.uncomplete
      else
        json_response['completed'] = true
        todo.complete
      end
      todo.save
    end

    respond_to do |format|
      format.html { render :json => json_response}
      format.json { render :json => json_response }
    end
  end

  def create
    @todo = Todo.new params[:todo]
    @todo.user = current_user
    @todo.parse

    json_response = {:created => false}

    if @todo.save
      json_response["created"] = true
      json_response["new_id"] = @todo.id
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render :json => json_response }
    end
  end

  def destroy
    id = params[:id]
    json_response = {'deleted' => false}

    todo = Todo.find_by_id id

    if todo and todo.user_id == current_user.id
      todo.destroy
      json_response['deleted'] = true
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render :json => json_response }
    end
  end
end
