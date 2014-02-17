###
# REST controller for fetching +TodoContext+ records

class TodoContextsController < ApplicationController
  before_filter :authenticate_user!

  # GET /contexts
  # @return [void]
  def index
    @contexts = current_user.todo_contexts

    respond_to do |format|
      format.html{ render :json => @contexts }
      format.json { render :json => @contexts }
    end
  end

  # DELETE /contexts
  # @return [void]
  def destroy
    id = params[:id]
    json_response = {'deleted' => false}

    context = TodoContext.find_by_id id

    if context and context.user_id == current_user.id
      current_user.todos.strip_text! '@'+context.name
      context.destroy
      json_response['deleted'] = true
    end

    respond_to do |format|
      format.html { render :json => json_response }
      format.json { render :json => json_response }
    end
  end

end
