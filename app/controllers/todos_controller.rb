class TodosController < ApplicationController

  def complete
    id = params[:id]

    json_response = {'completed' => false}

    todo = Todo.find_by_id id
    if todo and todo.user_id == current_user.id
      todo.complete
      todo.save
      json_response['completed'] = true
    end

    respond_to do |format|
      format.html { render :json => json_response}
      format.json { render :json => json_response }
    end
  end

  def create
    @todo = Todo.new params[:todo]
    @todo.user_id = current_user.id

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
end
