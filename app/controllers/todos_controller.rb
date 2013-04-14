###
# REST controller for fetching +Todo+ records

class TodosController < ApplicationController
  before_filter :authenticate_user!

  # GET /todos
  # @return [void]
  def index
    todos = get_todos_by_params

    respond_to do |format|
      format.html {
          render :json => todos
      }
    end
  end

  # GET /todos/1
  # @return [void]
  def show
    id = params[:id]
    todo = Todo.find_by_id id

    if todo.nil? or todo.user_id != current_user.id
      raise "Could not access todo"
    end

    respond_to do |format|
      format.html { render :json => todo}
      format.json { render :json => todo }
    end
  end

  # GET /todos/1/complete
  # @return [void]
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
      todo.parse
    end

    respond_to do |format|
      format.html { render :json => json_response}
      format.json { render :json => json_response }
    end
  end

  # PUT /todos/1
  # @return [void]
  def update
    todo = Todo.find_by_id params[:id]

    if todo.nil? or todo.user_id != current_user.id
      raise "Could not access todo"
    end

    todo.update_attributes :description => params[:description]
    todo.parse

    respond_to do |format|
      format.html { render :json => todo }
      format.json { render :json => todo }
    end
  end

  # POST /todos
  # @return [void]
  def create
    todo = Todo.new params[:todo]
    todo.user = current_user

    json_response = {}
    status = 200
    if todo.save
      todo.parse
      json_response[:id] = todo.id
      json_response[:description] = todo.parsed_description
      json_response[:saved] = true
    else
      status = 500
      json_response[:saved] = false
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render :json => json_response, status: status }
    end
  end

  # DELETE /todos
  # @return [void]
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

  private

  def get_todos_by_params
    conditions = {:user_id => current_user.id}

    if params[:context_id]
      conditions['todo_contexts.id'] = params[:context_id]
    end

    if params[:tag_id]
      conditions['tags.id'] = params[:tag_id]
    end

    if params[:project_id]
      conditions[:project_id] = params[:project_id]
    end

    if params[:completed] and params[:completed] == '1'
      conditions[:completed] = true
      todos = Todo.includes(:todo_contexts, :tags).where(conditions).order('todos.completed_time DESC')
    else
      conditions[:completed] = false
      todos = Todo.includes(:todo_contexts, :tags).where(conditions).order('todos.created_at DESC')
    end

    todos
  end

end
