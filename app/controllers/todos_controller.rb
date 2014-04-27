###
# REST controller for fetching +Todo+ records

class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_todo, except: [:index, :create]

  # GET /todos
  # @return [void]
  def index
    todos = current_user.todos_for_options(todo_search_params)

    respond_to do |format|
      format.html {
          render :json => todos
      }
    end
  end

  # GET /todos/1
  # @return [void]
  def show
    respond_to do |format|
      format.html { render :json => @todo}
      format.json { render :json => @todo }
    end
  end

  # GET /todos/1/complete
  # @return [void]
  def complete
    json_response = {'completed' => false}

    if params.include? :complete and ["0", "false"].include? params[:complete]
      json_response['completed'] = false
      @todo.uncomplete
    else
      json_response['completed'] = true
      @todo.complete
    end
    @todo.save
    @todo.parse

    respond_to do |format|
      format.html { render :json => json_response}
      format.json { render :json => json_response }
    end
  end

  # PUT /todos/1/toggle_tickler_status
  # @return [void]
  def toggle_tickler_status
    @todo.toggle_tickler_status
    @todo.save!

    json_response = {'tickler' => @todo.tickler}

    respond_to do |format|
      format.html { render :json => json_response}
      format.json { render :json => json_response }
    end
  end

  # PUT /todos/1
  # @return [void]
  def update
    @todo.update_attributes :description => params[:description]
    @todo.parse

    respond_to do |format|
      format.html { render :json => @todo }
      format.json { render :json => @todo }
    end
  end

  # PUT /todos/1/reorder
  # @return [void]
  def reorder
    if params[:prior_todo_id]
      prior_todo = current_user.todos.find(params[:prior_todo_id])
      new_ranking = prior_todo.ranking + 1
    else
      new_ranking = 1
    end

    if Todo.where(ranking: new_ranking, user_id: current_user.id).exists?
      Todo.where(user_id: current_user)
        .where('ranking >= ?', new_ranking)
        .update_all('ranking = ranking + 1')
    end

    @todo.update_attributes!(ranking: new_ranking)

    respond_to do |format|
      format.html { render :json => @todo }
      format.json { render :json => @todo }
    end
  end

  # POST /todos
  # @return [void]
  def create
    @todo = Todo.new params[:todo]
    @todo.user = current_user

    json_response = {}
    status = 200
    if @todo.save
      @todo.parse
      json_response[:id] = @todo.id
      json_response[:description] = @todo.parsed_description
      json_response[:saved] = true
    else
      status = 500
      json_response[:saved] = false
    end

    respond_to do |format|
      format.html { render :json => json_response, status: status }
      format.json { render :json => json_response, status: status }
    end
  end

  # DELETE /todos
  # @return [void]
  def destroy
    @todo.destroy
    json_response = {}
    json_response['deleted'] = true

    respond_to do |format|
      format.html { render :json => json_response }
      format.json { render :json => json_response }
    end
  end

  private

  def todo_search_params
    params.slice(:completed, :context_id, :tag_id, :project_id, :tickler)
  end

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end
end
